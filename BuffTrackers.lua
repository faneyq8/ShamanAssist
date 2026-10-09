local _, addon = ...
local keys={}
for _,key in ipairs(addon.order) do if addon.info[key].kind=="activeBuff" then keys[#keys+1]=key end end
local driver=CreateFrame("Frame")
local elapsed=0

local function ReadTiming(state,aura,instance)
    if type(aura)=="table" then
        state.aura=aura
        state.count=addon:Public(aura.applications,"number")
        state.expiration=addon:Public(aura.expirationTime,"number")
        state.totalDuration=addon:Public(aura.duration,"number")
        instance=instance or addon:Public(aura.auraInstanceID,"number")
    end
    if instance and not (state.totalDuration==0 and state.expiration==0) then
        state.durationObject=addon:SafeCall(C_UnitAuras and C_UnitAuras.GetAuraDuration,"player",instance)
    end
    if state.expiration and state.expiration>0 and state.expiration<=GetTime() then
        state.active=false; state.status="Expired"
    end
    if state.durationObject and addon:SafeCall(state.durationObject.HasExpired,state.durationObject)==true then
        state.active=false; state.status="Expired"
    end
end
function addon:ReadBuffTracker(key,state)
    if self:ReadHeroTotem(self.info[key],state) then return end
    local aura,readable=self:ReadAura(self.info[key].aura)
    if aura then
        state.active=true;state.status="Buff present"
        ReadTiming(state,aura)
        return
    end
    -- Only known native Tracked Buff items are presence sources.
    local inactive=false
    for frame,entry in pairs(self.external or {}) do
        if entry.valid and entry.buffSource and entry.keys[key] then
            local active,ok=self:SafeCall(frame.IsActive,frame)
            if ok and type(active)=="boolean" then
                if active then
                    state.active=true;state.status="Tracked Buff present"
                    local cached=self:SafeCall(frame.GetAuraDataCached,frame) or self:Public(frame.auraDataCached,"table")
                    local instance=self:Public(self:SafeCall(frame.GetAuraSpellInstanceID,frame),"number")
                        or self:Public(frame.auraInstanceID,"number")
                    ReadTiming(state,cached,instance)
                    return
                end
                inactive=true
            end
        end
    end
    state.status=(inactive or readable) and "Buff inactive" or "Buff unavailable: add to Tracked Buffs"
end

function addon:CreateBuffDisplay(key,display,makeDraggable)
    local timeline=CreateFrame("Frame","ShamanAssistTimeline_"..key,UIParent,"BackdropTemplate")
    timeline:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
    timeline:SetBackdropColor(.015,.025,.045,.96);timeline:SetBackdropBorderColor(.16,.35,.55,1)
    local bar=CreateFrame("StatusBar",nil,timeline)
    bar:SetPoint("TOPLEFT",2,-2);bar:SetPoint("BOTTOMRIGHT",-2,2)
    bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8");bar:SetMinMaxValues(0,1)
    timeline.fill=bar
    timeline.name=bar:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    timeline.name:SetPoint("LEFT",8,0);timeline.name:SetText(self.info[key].name)
    timeline.time=bar:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    timeline.time:SetPoint("RIGHT",-8,0)
    makeDraggable(timeline,key,"timelinePoint")
    display.iconTime=display.icon:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
    display.iconTime:SetPoint("TOP",display.icon,"BOTTOM",0,-4)
    display.timeline=timeline
    timeline:Hide()
end
function addon:ApplyBuffDisplaySettings(key)
    local display=self.displays[key]
    local s=ShamanAssistDB.alerts[key]
    local position=s.timelinePoint
    display.timeline:ClearAllPoints()
    display.timeline:SetPoint(position[1],UIParent,position[2],position[3],position[4])
    display.timeline:SetSize(math.max(160,math.min(500,s.timelineWidth)),math.max(16,math.min(48,s.timelineHeight)))
    display.timeline:SetAlpha(s.alpha)
    display.timeline.fill:SetStatusBarColor(s.color.r,s.color.g,s.color.b,.85)
    display.timeline:EnableMouse(not ShamanAssistDB.locked)
end
local function SetRemainingText(display,remaining)
    -- remaining may be secret: feed it to the native formatter without
    -- arithmetic, comparison or conversion through Lua's string.format.
    pcall(display.iconTime.SetFormattedText,display.iconTime,"%.1fs",remaining)
    pcall(display.timeline.time.SetFormattedText,display.timeline.time,"%.1fs",remaining)
end
local function UpdateTimer(key)
    local state=addon.states[key]
    local display=addon.displays[key]
    local testing=addon:IsTesting(key)
    if testing then
        local total=addon.testEndsAt-addon.testStartedAt
        local remaining=addon.layoutEditing and total or math.max(0,addon.testEndsAt-GetTime())
        display.timeline.fill:SetValue(remaining/total)
        SetRemainingText(display,remaining)
        return
    end
    if state.durationObject then
        local object=state.durationObject
        local expired=addon:SafeCall(object.HasExpired,object)
        if expired==true then
            state.active=false;state.status="Expired"
            addon:RenderAlert(key);addon:UpdateExternalGlows();return
        end
        display.timeline.time:SetText("--");display.iconTime:SetText("--")
        local ok,value=pcall(object.GetRemainingPercent,object)
        if ok then pcall(display.timeline.fill.SetValue,display.timeline.fill,value) end
        local timeOK,remaining=pcall(object.GetRemainingDuration,object)
        if timeOK then SetRemainingText(display,remaining) end
        return
    end
    if state.expiration and state.expiration>0 and state.totalDuration and state.totalDuration>0 then
        local remaining=math.max(0,state.expiration-GetTime())
        display.timeline.fill:SetValue(math.min(1,remaining/state.totalDuration))
        SetRemainingText(display,remaining)
        if remaining==0 and state.active then
            state.active=false;state.status="Expired"
            addon:RenderAlert(key)
            addon:UpdateExternalGlows()
        end
        return
    end
    -- Permanent or unavailable duration: show presence, never invent a timer.
    display.timeline.fill:SetValue(0)
    local label=state.totalDuration==0 and state.expiration==0 and "Active" or "--"
    display.timeline.time:SetText(label);display.iconTime:SetText(label)
end
local function Tick(_,delta)
    elapsed=elapsed+delta
    if elapsed<.10 then return end
    elapsed=0
    for _,key in ipairs(keys) do
        local display=addon.displays[key]
        if display.timerRunning then UpdateTimer(key) end
    end
end
function addon:RefreshBuffTimerDriver()
    local visible=false
    for _,key in ipairs(keys) do
        local d=self.displays[key]
        if d and d.timerRunning then visible=true;break end
    end
    driver:SetScript("OnUpdate",visible and Tick or nil)
end
function addon:RenderBuffDisplay(key,testing,active)
    local display=self.displays[key]
    local s=ShamanAssistDB.alerts[key]
    local state=self.states[key]
    local showTimeline=active and (s.timelineEnabled or self.testKey=="all")
    display.timeline:SetShown(showTimeline)
    display.timeline:SetFrameStrata(testing and "FULLSCREEN_DIALOG" or "MEDIUM")
    local showTime=s.durationText or self.testKey=="all"
    display.iconTime:SetShown(showTime)
    display.timeline.time:SetShown(showTime)
    display.icon.count:SetText("")
    if (s.showStacks or self.testKey=="all") and active then
        if testing and key=="tempestBuff" then display.icon.count:SetText("2")
        elseif state.count and state.count>1 then display.icon.count:SetText(state.count)
        elseif state.aura and C_UnitAuras.GetAuraApplicationDisplayCount then
            local instance=self:Public(state.aura.auraInstanceID,"number")
            if instance then
                local ok,value=pcall(C_UnitAuras.GetAuraApplicationDisplayCount,"player",instance,2)
                if ok then pcall(display.icon.count.SetText,display.icon.count,value) end
            end
        end
    end
    display.timerVisible=active and (showTimeline or (showTime and display.icon:IsShown())) or false
    display.timerRunning=display.timerVisible and (testing or state.durationObject~=nil
        or (state.expiration~=nil and state.expiration>0 and state.totalDuration~=nil and state.totalDuration>0)) or false
    display.iconTime:SetText("");display.timeline.time:SetText("")
    if display.timerVisible then UpdateTimer(key) end
    self:RefreshBuffTimerDriver()
end
-- Exposed only for local verification; no separate polling timer is created.
addon.buffTimerDriver=driver
