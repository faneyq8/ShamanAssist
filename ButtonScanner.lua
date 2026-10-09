-- Discovery paths adapted from DK Assist 2.1.9. Never scan the whole UI.
local _, addon = ...
addon.external = {}
local hookedViewers, hookedEllesmere = {}, {}
local names = {}
for i=1,12 do
    for _, prefix in ipairs({"ActionButton","MultiBarBottomLeftButton","MultiBarBottomRightButton","MultiBarRightButton","MultiBarLeftButton","MultiBar5Button","MultiBar6Button","MultiBar7Button"}) do names[#names+1]=prefix..i end
end
for i=1,180 do names[#names+1]="BT4Button"..i; names[#names+1]="EABButton"..i end
for i=1,168 do names[#names+1]="DominosActionButton"..i end
for bar=1,10 do for i=1,12 do names[#names+1]="ElvUI_Bar"..bar.."Button"..i end end

local function Number(value)
    value=addon:Public(value,"number")
    if value and value>0 then return value end
end
local function ReadNumber(fn, ...) return Number(addon:SafeCall(fn,...)) end
local function ActionSpell(frame)
    local slot = ReadNumber(frame.GetAction, frame) or Number(frame._state_action) or Number(frame.action)
        or ReadNumber(frame.GetAttribute, frame, "action")
    if slot then
        local ok, kind, id = pcall(GetActionInfo, slot)
        kind, id = addon:Public(kind,"string"), Number(id)
        if ok and id then
            if kind == "spell" then return id end
            if kind == "macro" then return ReadNumber(GetMacroSpell,id) end
        end
        return nil
    end
    return Number(frame.spellID) or Number(frame.spellId)
end
local function CDMSpell(frame)
    local eui=EllesmereUI and EllesmereUI._ModuleNS and EllesmereUI._ModuleNS["EllesmereUICooldownManager"]
    local cache=eui and eui._ecmeFC and eui._ecmeFC[frame]
    local data=eui and eui._hookFrameData and eui._hookFrameData[frame]
    local id = (eui and ReadNumber(eui.GetCanonicalSpellIDForFrame,frame))
        or ReadNumber(frame.GetSpellID,frame) or (cache and (Number(cache.resolvedSid) or Number(cache.baseSpellID) or Number(cache.spellID)))
        or Number(frame._phSpellID) or (data and Number(data.spellID))
        or Number(frame.overrideSpellID) or Number(frame.spellID) or Number(frame.spellId)
    if id then return id end
    local cooldownID = ReadNumber(frame.GetCooldownID,frame) or Number(frame.cooldownID)
    if cooldownID and C_CooldownViewer and C_CooldownViewer.GetCooldownViewerCooldownInfo then
        local info = addon:SafeCall(C_CooldownViewer.GetCooldownViewerCooldownInfo,cooldownID)
        if type(info)=="table" then return Number(info.overrideSpellID) or Number(info.spellID) end
    end
end
local function KeysFor(id)
    local keys = {}
    for _, key in ipairs(addon.order) do
        local info = addon.info[key]
        if info.aura == id then keys[key]=true end
        for _, aura in ipairs(info.auras or {}) do if aura==id then keys[key]=true end end
        for _, spell in ipairs(info.spells) do if spell==id then keys[key]=true end end
    end
    return keys
end
local function Register(frame,kind,id,buffSource)
    if not frame or not id then return end
    local keys=KeysFor(id)
    if not next(keys) then return end
    local entry=addon.external[frame]
    if not entry then
        local overlay=CreateFrame("Frame",nil,frame)
        overlay:SetAllPoints(frame); overlay:EnableMouse(false)
        overlay:SetFrameLevel(frame:GetFrameLevel()+5); overlay:Hide()
        entry={overlay=overlay}; addon.external[frame]=entry
        if frame.HookScript then
            frame:HookScript("OnHide",function()
                addon:StopGlow(overlay); overlay:Hide()
            end)
            frame:HookScript("OnShow",function() addon:RequestScan() end)
        end
        local function Invalidate()
            entry.valid=false; addon:StopGlow(overlay); overlay:Hide(); addon:RequestScan()
            addon:QueueBuffRefresh()
        end
        if kind=="cdm" then
            for _, method in ipairs({"SetCooldownID","SetSpellID"}) do
                if type(frame[method])=="function" then hooksecurefunc(frame,method,function()
                    -- Blizzard may reassign the same item during combat. Keep
                    -- its binding only when its public identity still matches.
                    if CDMSpell(frame)==entry.spellID then addon:QueueBuffRefresh()
                    else Invalidate() end
                end) end
            end
            if type(frame.ClearCooldownID)=="function" then hooksecurefunc(frame,"ClearCooldownID",Invalidate) end
            for _,method in ipairs({"OnAuraInstanceInfoSet","OnAuraInstanceInfoCleared"}) do
                if type(frame[method])=="function" then hooksecurefunc(frame,method,function() addon:QueueBuffRefresh() end) end
            end
            if type(frame.SetIsActive)=="function" then
                hooksecurefunc(frame,"SetIsActive",function()
                    if entry.buffSource then addon:QueueBuffRefresh() end
                end)
            end
        end
    end
    entry.kind,entry.keys,entry.valid=kind,keys,true
    entry.spellID=id
    entry.buffSource=buffSource==true
end
function addon:QueueBuffRefresh()
    if self.buffRefreshQueued then return end
    self.buffRefreshQueued=true
    C_Timer.After(0,function()
        self.buffRefreshQueued=false
        if self.displays then self:RefreshState() end
    end)
end
function addon:ScanButtons()
    if InCombatLockdown() then self.scanPending=true; return end
    for _, entry in pairs(self.external) do entry.valid=false; self:StopGlow(entry.overlay); entry.overlay:Hide() end
    if not self.isSupported or not ShamanAssistDB.enabled then return end
    local seen={}
    local function Check(frame,kind,buffSource)
        if not frame or seen[frame] then return end
        seen[frame]=true
        local id
        if kind=="action" then id=ActionSpell(frame) else id=CDMSpell(frame) end
        if kind=="cdm" then
            local ns=EllesmereUI and EllesmereUI._ModuleNS and EllesmereUI._ModuleNS["EllesmereUICooldownManager"]
            local fd=ns and ns._hookFrameData and ns._hookFrameData[frame]
            local viewer=frame.viewerFrame
            buffSource=buffSource or (viewer~=nil and (viewer==BuffIconCooldownViewer or viewer==BuffBarCooldownViewer))
                or (fd and addon:Public(fd._isBuffViewerFrame,"boolean")==true)
            if addon:Public(frame._isPlaceholderFrame,"boolean")==true then buffSource=false end
        end
        Register(frame,kind,id,buffSource)
    end
    for _, name in ipairs(names) do Check(_G[name],"action") end
    local registry=ActionBarButtonEventsFrame and ActionBarButtonEventsFrame.frames
    if registry then for key,value in pairs(registry) do Check(type(key)=="table" and key or value,"action") end end
    for _, name in ipairs({"EssentialCooldownViewer","UtilityCooldownViewer","BuffIconCooldownViewer","BuffBarCooldownViewer"}) do
        local viewer=_G[name]
        local buffSource=name=="BuffIconCooldownViewer" or name=="BuffBarCooldownViewer"
        if viewer then
            if not hookedViewers[viewer] and type(viewer.RefreshLayout)=="function" then
                hookedViewers[viewer]=true
                hooksecurefunc(viewer,"RefreshLayout",function() addon:RequestScan() end)
            end
            if viewer.itemFramePool and viewer.itemFramePool.EnumerateActive then
                for item in viewer.itemFramePool:EnumerateActive() do Check(item,"cdm",buffSource) end
            end
            if viewer.GetItemFrames then
                local frames=self:SafeCall(viewer.GetItemFrames,viewer)
                if type(frames)=="table" then for _, item in ipairs(frames) do Check(item,"cdm",buffSource) end end
            end
        end
    end
    local eui=_G.EllesmereUI and _G.EllesmereUI._ModuleNS and _G.EllesmereUI._ModuleNS["EllesmereUICooldownManager"]
    -- Native CDM pools above also cover Ellesmere versions that reparent items.
    if eui and type(eui.cdmBarIcons)=="table" then
        if not hookedEllesmere[eui] then
            hookedEllesmere[eui]=true
            for _,method in ipairs({"QueueReanchor","CollectAndReanchor"}) do
                if type(eui[method])=="function" then hooksecurefunc(eui,method,function() addon:RequestScan() end) end
            end
        end
        for _, list in pairs(eui.cdmBarIcons) do for _, frame in ipairs(list) do Check(frame,"cdm") end end
    end
    self.scanPending=false
    self:RefreshState()
end
function addon:RequestScan()
    if InCombatLockdown() then self.scanPending=true; return end
    if self.scanQueued then return end
    self.scanQueued=true
    C_Timer.After(0.15,function()
        self.scanQueued=false
        if ShamanAssistDB then self:ScanButtons() end
    end)
end
function addon:UpdateExternalGlows()
    for frame, entry in pairs(self.external) do
        local chosen
        if entry.valid then
            local visible=self:SafeCall(frame.IsVisible,frame)
            if visible==true then
                for _, key in ipairs(self.order) do
                    local s=ShamanAssistDB.alerts[key]
                    if entry.keys[key] and ((not self.testKey and self.states[key].active) or self:IsTesting(key))
                        and (self.testKey=="all" or (entry.kind=="action" and s.actionGlow) or (entry.kind=="cdm" and s.cdmGlow)) then chosen=s end
                end
            end
        end
        if chosen then
            entry.overlay:Show(); self:SetGlow(entry.overlay,true,chosen)
        else self:StopGlow(entry.overlay); entry.overlay:Hide() end
    end
end
local frame=CreateFrame("Frame")
for _, event in ipairs({"PLAYER_ENTERING_WORLD","PLAYER_REGEN_ENABLED","ACTIONBAR_SLOT_CHANGED","ACTIONBAR_PAGE_CHANGED","UPDATE_MACROS","UPDATE_SHAPESHIFT_FORM","ADDON_LOADED"}) do frame:RegisterEvent(event) end
frame:RegisterUnitEvent("UNIT_AURA","player")
frame:SetScript("OnEvent",function(_,event)
    if event=="UNIT_AURA" then addon:QueueBuffRefresh(); return end
    if event=="ACTIONBAR_SLOT_CHANGED" or event=="ACTIONBAR_PAGE_CHANGED" or event=="UPDATE_MACROS" or event=="UPDATE_SHAPESHIFT_FORM" then
        -- Pages/macros can change in combat: clear stale matches immediately.
        for _,entry in pairs(addon.external) do
            if entry.kind=="action" then entry.valid=false; addon:StopGlow(entry.overlay); entry.overlay:Hide() end
        end
    end
    if ShamanAssistDB then addon:RequestScan() end
    if event=="PLAYER_ENTERING_WORLD" then C_Timer.After(3,function() addon:RequestScan() end) end
end)
