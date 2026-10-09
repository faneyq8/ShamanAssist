local _, addon = ...
local backdrop = { bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 }

function addon:StopGlow(frame)
    if frame.saGlow then
        local glow = self.GLOW_TYPE_MAP[frame.saGlow]
        if glow then pcall(glow.stop, frame) end
        frame.saGlow = nil
        frame.saSettings = nil
    end
end
function addon:SetGlow(frame, active, settings)
    local style = self.GLOW_TYPE_MAP[settings.glowType] or self.GLOW_TYPE_MAP.pixel
    if not active or frame.saGlow ~= style.id or frame.saSettings ~= settings then self:StopGlow(frame) end
    if active and not frame.saGlow then
        local ok = pcall(style.start, frame, settings)
        if ok then frame.saGlow = style.id; frame.saSettings = settings end
    end
end
local function Draggable(frame, key, field)
    frame:SetMovable(true); frame:SetClampedToScreen(true); frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        if not ShamanAssistDB.locked and not InCombatLockdown() then self:StartMoving() end
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relative, x, y = self:GetPoint()
        ShamanAssistDB.alerts[key][field] = {point, relative, x, y}
    end)
end
local function Position(frame, position)
    frame:ClearAllPoints()
    frame:SetPoint(position[1], UIParent, position[2], position[3], position[4])
end
function addon:CreateDisplays()
    if self.displays then return end
    self.displays = {}
    for _, key in ipairs(self.order) do
        local info = self.info[key]
        local frame = CreateFrame("Frame", "ShamanAssistIcon_" .. key, UIParent, "BackdropTemplate")
        frame:SetFrameStrata("MEDIUM"); frame:SetBackdrop(backdrop)
        frame:SetBackdropColor(0.015,0.025,0.045,0.95); frame:SetBackdropBorderColor(0.15,0.35,0.55,1)
        frame.icon = frame:CreateTexture(nil, "ARTWORK")
        frame.icon:SetPoint("TOPLEFT",2,-2); frame.icon:SetPoint("BOTTOMRIGHT",-2,2)
        local texture = info.texture or self:SafeCall(C_Spell and C_Spell.GetSpellTexture, info.icon)
        frame.icon:SetTexture(texture or "Interface\\Icons\\Spell_Nature_Lightning")
        frame.icon:SetTexCoord(0.07,0.93,0.07,0.93)
        frame.count = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        frame.count:SetPoint("CENTER"); frame.count:SetTextColor(1,1,1)
        frame.label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.label:SetPoint("BOTTOM",frame,"TOP",0,5); frame.label:SetText(info.name)
        frame.label:Hide()
        Draggable(frame, key, "point")
        frame:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:SetText(info.name)
            GameTooltip:AddLine(addon.states[key].status,0.7,0.8,0.9)
            GameTooltip:Show()
        end)
        frame:SetScript("OnLeave",function() GameTooltip:Hide() end)
        local text = CreateFrame("Frame", "ShamanAssistText_" .. key, UIParent)
        text:SetFrameStrata("MEDIUM"); text:SetSize(500,48)
        text.label = text:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
        text.label:SetPoint("CENTER"); Draggable(text,key,"textPoint")
        if info.kind == "stacks" then
            frame.bar = CreateFrame("StatusBar",nil,frame)
            frame.bar:SetPoint("TOPLEFT",frame,"BOTTOMLEFT",0,-5)
            frame.bar:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",0,-5)
            frame.bar:SetHeight(7); frame.bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
            frame.bar:SetMinMaxValues(0,10)
            local bg = frame.bar:CreateTexture(nil,"BACKGROUND")
            bg:SetAllPoints(); bg:SetColorTexture(0.02,0.04,0.08,0.9)
        end
        self.displays[key] = { icon=frame, text=text, active=false }
        if info.kind == "activeBuff" then self:CreateBuffDisplay(key,self.displays[key],Draggable) end
        frame:Hide(); text:Hide()
    end
    self:ApplyDisplaySettings()
end
function addon:ApplyDisplaySettings()
    for _, key in ipairs(self.order) do
        local display = self.displays and self.displays[key]
        if display then
            local s = ShamanAssistDB.alerts[key]
            Position(display.icon,s.point); Position(display.text,s.textPoint)
            display.icon:SetSize(s.size,s.size)
            display.icon:SetAlpha(s.alpha); display.text:SetAlpha(s.alpha)
            display.text.label:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF",s.fontSize,"OUTLINE")
            display.text.label:SetText(s.text)
            display.text.label:SetTextColor(s.color.r,s.color.g,s.color.b)
            display.icon.count:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF",math.max(16,s.size*0.48),"OUTLINE")
            display.icon:EnableMouse(not ShamanAssistDB.locked)
            display.text:EnableMouse(not ShamanAssistDB.locked)
            if display.icon.bar then display.icon.bar:SetStatusBarColor(s.color.r,s.color.g,s.color.b) end
            self:StopGlow(display.icon)
            if self.info[key].kind == "activeBuff" then self:ApplyBuffDisplaySettings(key) end
        end
    end
    if self.external then for _, entry in pairs(self.external) do self:StopGlow(entry.overlay) end end
end
function addon:RenderAlert(key)
    local display = self.displays and self.displays[key]
    if not display then return end
    local state, s = self.states[key], ShamanAssistDB.alerts[key]
    local testing = self:IsTesting(key)
    local testAll = testing and self.testKey == "all"
    -- Previews must be visible above the settings window, then return to
    -- their normal gameplay layer when the preview ends.
    local strata = testing and "FULLSCREEN_DIALOG" or "MEDIUM"
    display.icon:SetFrameStrata(strata)
    display.text:SetFrameStrata(strata)
    local moving = testing and not ShamanAssistDB.locked
    local active = testing or (not self.testKey and state.active)
    local isStacks = self.info[key].kind == "stacks"
    local showStacks = not self.testKey and isStacks and state.visible and (s.alwaysShow or state.count == nil or state.count > 0)
    local showIcon = testAll or (s.iconEnabled and (active or showStacks))
    display.icon:SetShown(showIcon or moving)
    display.text:SetShown(testAll or (s.textEnabled and active) or moving)
    display.icon.label:SetShown(moving)
    if self.info[key].kind == "activeBuff" then self:RenderBuffDisplay(key,testing,active) end
    self:SetGlow(display.icon, active and showIcon, s)
    if isStacks then
        local count = testing and 10 or state.count
        display.icon.count:SetText(count ~= nil and tostring(count) or "?")
        if count == nil and state.aura and C_UnitAuras.GetAuraApplicationDisplayCount then
            local instance = self:Public(state.aura.auraInstanceID, "number")
            if instance then
                -- This API's output may be secret. Pass it straight to SetText;
                -- never inspect it, stringify it, or use it for threshold logic.
                local ok, value = pcall(C_UnitAuras.GetAuraApplicationDisplayCount,"player",instance,1)
                if ok then pcall(display.icon.count.SetText,display.icon.count,value) end
            end
        end
        display.icon.bar:SetShown((testAll or s.barEnabled) and count ~= nil)
        if count ~= nil then display.icon.bar:SetValue(math.min(10,count)) end
    end
    if active and not display.active and s.sound and not testing then
        PlaySound(SOUNDKIT.RAID_WARNING,"Master")
    end
    display.active = active
end
