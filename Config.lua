-- Controls and theme palettes adapted from DK Assist 2.1.9 (MIT).
local _, addon = ...
local THEME_ITEMS = {
    { text = "Classic", value = "classic" },
    { text = "Carbon Cyan", value = "carbon" },
    { text = "Graphite Red", value = "graphite" },
    { text = "Obsidian Lime", value = "obsidian" },
    { text = "Frosted Blue", value = "frosted" },
    { text = "Slate Orange", value = "slate" },
    { text = "Emerald Green", value = "unholy" },
}

local STANDALONE_THEMES = {
    carbon = {
        titleCode = "33d6e8", accent = { 0.20, 0.84, 0.91 },
        window = { 0.010, 0.020, 0.024 }, panel = { 0.014, 0.030, 0.035 },
        card = { 0.018, 0.040, 0.047 }, control = { 0.025, 0.080, 0.090 },
        border = { 0.12, 0.43, 0.48 }, text = { 0.78, 0.92, 0.94 }, subtext = { 0.62, 0.74, 0.77 },
    },
    graphite = {
        titleCode = "f0525a", accent = { 0.94, 0.25, 0.30 },
        window = { 0.025, 0.026, 0.029 }, panel = { 0.040, 0.041, 0.045 },
        card = { 0.055, 0.055, 0.060 }, control = { 0.090, 0.075, 0.080 },
        border = { 0.42, 0.17, 0.19 }, text = { 0.92, 0.88, 0.89 }, subtext = { 0.72, 0.68, 0.69 },
    },
    obsidian = {
        titleCode = "97df20", accent = { 0.58, 0.88, 0.12 },
        window = { 0.008, 0.012, 0.009 }, panel = { 0.014, 0.022, 0.016 },
        card = { 0.022, 0.035, 0.025 }, control = { 0.045, 0.075, 0.050 },
        border = { 0.24, 0.42, 0.18 }, text = { 0.86, 0.92, 0.84 }, subtext = { 0.66, 0.74, 0.64 },
    },
    frosted = {
        titleCode = "4da3ff", accent = { 0.30, 0.64, 1.00 },
        window = { 0.012, 0.024, 0.040 }, panel = { 0.018, 0.035, 0.055 },
        card = { 0.018, 0.043, 0.070 }, control = { 0.035, 0.075, 0.105 },
        border = { 0.10, 0.25, 0.40 }, text = { 0.82, 0.90, 1.00 }, subtext = { 0.67, 0.75, 0.84 },
    },
    slate = {
        titleCode = "ff861f", accent = { 1.00, 0.48, 0.08 },
        window = { 0.045, 0.052, 0.057 }, panel = { 0.060, 0.068, 0.074 },
        card = { 0.075, 0.083, 0.090 }, control = { 0.105, 0.105, 0.105 },
        border = { 0.40, 0.28, 0.16 }, text = { 0.92, 0.90, 0.87 }, subtext = { 0.72, 0.70, 0.67 },
    },
    unholy = {
        titleCode = "28e060", accent = { 0.16, 0.88, 0.38 },
        window = { 0.008, 0.022, 0.014 }, panel = { 0.012, 0.038, 0.023 },
        card = { 0.016, 0.052, 0.030 }, control = { 0.025, 0.090, 0.048 },
        border = { 0.10, 0.40, 0.22 }, text = { 0.80, 0.96, 0.85 }, subtext = { 0.62, 0.80, 0.68 },
    },
}

local PRESETS = {
    { 0.00, 0.90, 0.20 },
    { 0.40, 0.80, 1.00 },
    { 1.00, 0.20, 0.20 },
    { 0.70, 0.30, 1.00 },
    { 1.00, 0.85, 0.00 },
    { 1.00, 1.00, 1.00 },
}

local TEXT_FONTS = {
    { text = "Friz Quadrata", value = "Fonts\\FRIZQT__.TTF" },
    { text = "Arial Narrow", value = "Fonts\\ARIALN.TTF" },
    { text = "Morpheus", value = "Fonts\\MORPHEUS.TTF" },
    { text = "Skurri", value = "Fonts\\SKURRI.TTF" },
    { text = "2002", value = "Fonts\\2002.TTF" },
}

local TEXT_OUTLINES = {
    { text = "No Outline", value = "" },
    { text = "Thin Outline", value = "OUTLINE" },
    { text = "Thick Outline", value = "THICKOUTLINE" },
}

local function GetSpellTextureSafe(spellID, fallback)
    if C_Spell and C_Spell.GetSpellTexture then
        local ok, texture = pcall(C_Spell.GetSpellTexture, spellID)
        if ok and texture then return texture end
    end
    return fallback or "Interface\\Icons\\Spell_Nature_Lightning"
end

local function CreateCard(parent, titleText)
    local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    card:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    card:SetBackdropColor(0.012, 0.012, 0.018, 0.98)
    card:SetBackdropBorderColor(0.25, 0.25, 0.27, 1)

    local title = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", card, "TOP", 0, -9)
    title:SetText(titleText)
    card.title = title

    local left = card:CreateTexture(nil, "OVERLAY")
    left:SetTexture("Interface\\Buttons\\WHITE8X8")
    left:SetHeight(1)
    -- Keep the ornamental dividers inside narrow cards, including the long
    -- Text Alert titles.
    left:SetWidth(40)
    left:SetVertexColor(0.68, 0.55, 0.10, 0.75)
    left:SetPoint("RIGHT", title, "LEFT", -7, 0)
    card.leftDivider = left
    local right = card:CreateTexture(nil, "OVERLAY")
    right:SetTexture("Interface\\Buttons\\WHITE8X8")
    right:SetHeight(1)
    right:SetWidth(40)
    right:SetVertexColor(0.68, 0.55, 0.10, 0.75)
    right:SetPoint("LEFT", title, "RIGHT", 7, 0)
    card.rightDivider = right
    return card
end

local function AdjustedY(parent, y)
    return y + (parent.shamanassistHiddenSelectorOffset or 0)
end

local themedLabels, themedButtons, themedChecks = {}, {}, {}
local function CreateText(parent, text, x, y, fontObject, width, color)
    local fs = parent:CreateFontString(nil, "OVERLAY", fontObject or "GameFontNormal")
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, AdjustedY(parent, y))
    fs:SetJustifyH("LEFT")
    if width then fs:SetWidth(width) end
    fs:SetText(text or "")
    if color then fs:SetTextColor(color[1], color[2], color[3], color[4] or 1) end
    themedLabels[#themedLabels+1]=fs
    return fs
end

local function CreateCheck(parent, text, x, y, getter, setter)
    local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", parent, "TOPLEFT", x, AdjustedY(parent, y))
    check.Text:SetText(text)
    check.Text:SetFontObject("GameFontNormal")
    themedLabels[#themedLabels+1]=check.Text
    themedChecks[#themedChecks+1]=check
    check:SetScript("OnClick", function(self)
        setter(self:GetChecked() and true or false)
    end)
    check.refresh = function() check:SetChecked(getter() and true or false) end
    return check
end

local dropdownSerial = 0
local activeStandalonePanel

local function AttachModernDropdown(dd, parent, width, itemsProvider, currentProvider, setter)
    if not activeStandalonePanel then return end
    local panel = activeStandalonePanel
    panel.shamanassistModernDropdowns = panel.shamanassistModernDropdowns or {}

    local modern = CreateFrame("Button", nil, parent, "BackdropTemplate")
    modern:SetSize(width + 28, 25)
    modern:SetPoint("TOPLEFT", dd, "TOPLEFT", 17, -3)
    modern:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    modern:SetBackdropColor(0.035, 0.075, 0.105, 1)
    modern:SetBackdropBorderColor(0.20, 0.36, 0.48, 1)
    modern:Hide()

    modern.label = modern:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    modern.label:SetPoint("LEFT", modern, "LEFT", 10, 0)
    modern.label:SetPoint("RIGHT", modern, "RIGHT", -25, 0)
    modern.label:SetJustifyH("LEFT")
    modern.arrow = modern:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    modern.arrow:SetPoint("RIGHT", modern, "RIGHT", -8, 1)
    modern.arrow:SetText("v")
    modern.arrow:SetTextColor(0.42, 0.69, 0.86, 1)

    local menu = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    menu:SetFrameStrata("TOOLTIP")
    menu:SetClampedToScreen(true)
    menu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    menu:SetBackdropColor(0.025, 0.065, 0.090, 0.99)
    menu:SetBackdropBorderColor(0.18, 0.55, 0.68, 1)
    menu:SetPoint("TOPLEFT", modern, "BOTTOMLEFT", 0, -2)
    menu:SetWidth(width + 28)
    menu:Hide()
    modern.menu = menu
    modern.rows = {}

    local function CloseMenu()
        menu:Hide()
        modern.arrow:SetText("v")
    end
    modern:SetScript("OnHide", CloseMenu)

    local function RefreshRows()
        local items = itemsProvider()
        local current = currentProvider()
        local palette = modern.palette or STANDALONE_THEMES.frosted
        local rowHeight = 22
        menu:SetHeight(math.max(8, (#items * rowHeight) + 6))
        for index, item in ipairs(items) do
            local itemValue = item.value
            local itemText = item.text
            local row = modern.rows[index]
            if not row then
                row = CreateFrame("Button", nil, menu, "BackdropTemplate")
                row:SetHeight(rowHeight)
                row:SetPoint("TOPLEFT", menu, "TOPLEFT", 3, -3 - ((index - 1) * rowHeight))
                row:SetPoint("RIGHT", menu, "RIGHT", -3, 0)
                row:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
                row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                row.text:SetPoint("LEFT", row, "LEFT", 10, 0)
                row.text:SetPoint("RIGHT", row, "RIGHT", -8, 0)
                row.text:SetJustifyH("LEFT")
                row:SetScript("OnEnter", function(self)
                    local p = modern.palette or STANDALONE_THEMES.frosted
                    self:SetBackdropColor(p.accent[1] * 0.20, p.accent[2] * 0.20, p.accent[3] * 0.20, 1)
                end)
                row:SetScript("OnLeave", function(self)
                    local p = modern.palette or STANDALONE_THEMES.frosted
                    self:SetBackdropColor(self.selected and p.accent[1] * 0.14 or 0,
                        self.selected and p.accent[2] * 0.14 or 0,
                        self.selected and p.accent[3] * 0.14 or 0, self.selected and 1 or 0)
                end)
                modern.rows[index] = row
            end
            row.selected = current == itemValue
            row.text:SetText(itemText)
            row.text:SetTextColor(row.selected and palette.accent[1] or palette.text[1],
                row.selected and palette.accent[2] or palette.text[2],
                row.selected and palette.accent[3] or palette.text[3], 1)
            row:SetBackdropColor(row.selected and palette.accent[1] * 0.14 or 0,
                row.selected and palette.accent[2] * 0.14 or 0,
                row.selected and palette.accent[3] * 0.14 or 0, row.selected and 1 or 0)
            row:SetScript("OnClick", function()
                setter(itemValue)
                UIDropDownMenu_SetText(dd, itemText)
                UIDropDownMenu_SetSelectedValue(dd, itemValue)
                modern.label:SetText(itemText)
                CloseMenu()
            end)
            row:Show()
        end
        for index = #items + 1, #modern.rows do modern.rows[index]:Hide() end
    end

    modern:SetScript("OnClick", function()
        if menu:IsShown() then
            CloseMenu()
        else
            for _, other in ipairs(panel.shamanassistModernDropdowns) do
                if other ~= modern and other.menu then other.menu:Hide() end
            end
            RefreshRows()
            menu:Show()
            modern.arrow:SetText("^")
        end
    end)
    modern:SetScript("OnEnter", function(self)
        local p = modern.palette or STANDALONE_THEMES.frosted
        self:SetBackdropBorderColor(p.accent[1], p.accent[2], p.accent[3], 1)
    end)
    modern:SetScript("OnLeave", function(self)
        local p = modern.palette or STANDALONE_THEMES.frosted
        self:SetBackdropBorderColor(p.border[1], p.border[2], p.border[3], 1)
    end)

    modern.refresh = function()
        local current = currentProvider()
        local label = current
        for _, item in ipairs(itemsProvider()) do
            if item.value == current then label = item.text break end
        end
        modern.label:SetText(label or "")
        if menu:IsShown() then RefreshRows() end
    end
    modern.SetModernMode = function(_, enabled, palette)
        CloseMenu()
        if modern.shamanassistNavigationHidden then
            dd:Hide()
            modern:Hide()
            return
        end
        if palette then
            modern.palette = palette
            modern:SetBackdropColor(palette.control[1], palette.control[2], palette.control[3], 1)
            modern:SetBackdropBorderColor(palette.border[1], palette.border[2], palette.border[3], 1)
            modern.label:SetTextColor(palette.text[1], palette.text[2], palette.text[3], 1)
            modern.arrow:SetTextColor(palette.accent[1], palette.accent[2], palette.accent[3], 1)
            menu:SetBackdropColor(palette.control[1] * 0.72, palette.control[2] * 0.72, palette.control[3] * 0.72, 0.99)
            menu:SetBackdropBorderColor(palette.border[1], palette.border[2], palette.border[3], 1)
        end
        modern.enabled = enabled
        dd:SetControlShown(dd.shamanassistControlShown)
        if enabled then modern.refresh() end
    end
    dd.shamanassistModern = modern
    table.insert(panel.shamanassistModernDropdowns, modern)
end

local function CreateDropdown(parent, x, y, width, itemsProvider, currentProvider, setter)
    dropdownSerial = dropdownSerial + 1
    local dd = CreateFrame("Frame", "ShamanAssistV2Dropdown" .. dropdownSerial, parent, "UIDropDownMenuTemplate")
    -- Page visibility and theme selection are independent. Always update both
    -- renderers together so page refreshes cannot revive the Classic control.
    dd.shamanassistControlShown = true
    function dd:SetControlShown(shown)
        self.shamanassistControlShown = not not shown
        local modern = self.shamanassistModern
        local visible = self.shamanassistControlShown and not (modern and modern.shamanassistNavigationHidden)
        self:SetShown(visible and not (modern and modern.enabled))
        if modern then
            modern:SetShown(visible and modern.enabled or false)
            if not visible and modern.menu then modern.menu:Hide() end
        end
        if self.controlLabel then self.controlLabel:SetShown(visible) end
        if self.visibilityOwner then self.visibilityOwner:SetShown(visible) end
    end
    dd:SetPoint("TOPLEFT", parent, "TOPLEFT", x, AdjustedY(parent, y))
    UIDropDownMenu_SetWidth(dd, width)
    local function Init()
        UIDropDownMenu_Initialize(dd, function()
            local current = currentProvider()
            for _, item in ipairs(itemsProvider()) do
                local value, text = item.value, item.text
                local info = UIDropDownMenu_CreateInfo()
                info.text = text
                info.value = value
                info.checked = current == value
                info.func = function()
                    setter(value)
                    UIDropDownMenu_SetText(dd, text)
                    UIDropDownMenu_SetSelectedValue(dd, value)
                end
                UIDropDownMenu_AddButton(info)
            end
        end)
    end
    dd.refresh = function()
        Init()
        local current = currentProvider()
        local label = current
        for _, item in ipairs(itemsProvider()) do
            if item.value == current then label = item.text break end
        end
        UIDropDownMenu_SetText(dd, label or "")
        UIDropDownMenu_SetSelectedValue(dd, current)
        if dd.shamanassistModern then dd.shamanassistModern.refresh() end
        -- Native dropdown initialization can change visibility. Reapply the
        -- selected renderer after refreshing its text and menu state.
        dd:SetControlShown(dd.shamanassistControlShown)
    end
    AttachModernDropdown(dd, parent, width, itemsProvider, currentProvider, setter)
    return dd
end

local sliderSerial = 0
local function CreateSlider(parent, labelText, x, y, width, minValue, maxValue, step, getter, setter)
    sliderSerial = sliderSerial + 1
    local holder = CreateFrame("Frame", nil, parent)
    holder:SetPoint("TOPLEFT", parent, "TOPLEFT", x, AdjustedY(parent, y))
    holder:SetSize(width + 62, 42)
    local label = CreateText(holder, "", 0, 0, "GameFontNormal")
    local slider = CreateFrame("Slider", "ShamanAssistV2Slider" .. sliderSerial, holder, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
    slider:SetWidth(width)
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider.Low:SetText(minValue)
    slider.High:SetText(maxValue)
    local edit = CreateFrame("EditBox", nil, holder, "InputBoxTemplate")
    edit:SetSize(45, 20)
    edit:SetPoint("LEFT", slider, "RIGHT", 9, 0)
    edit:SetAutoFocus(false)
    local format = step < 1 and "%.2f" or "%d"
    local refreshing = false
    holder.refresh = function()
        local value = getter()
        if value == nil then return end
        refreshing = true
        slider:SetValue(value)
        label:SetText(labelText .. ": " .. string.format(format, value))
        edit:SetText(string.format(format, value))
        refreshing = false
    end
    slider:SetScript("OnValueChanged", function(_, value)
        if refreshing then return end
        setter(value)
        holder.refresh()
    end)
    edit:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            value = math.max(minValue, math.min(maxValue, value))
            setter(value)
        end
        self:ClearFocus()
        holder.refresh()
    end)
    return holder
end

local function CreateColorControl(parent, x, y, labelText, colorProvider, changed)
    local label = CreateText(parent, labelText, x, y, "GameFontNormal")
    local swatch = CreateFrame("Button", nil, parent)
    swatch:SetSize(25, 25)
    swatch:SetPoint("LEFT", label, "RIGHT", 8, 0)
    swatch.bg = swatch:CreateTexture(nil, "BACKGROUND")
    swatch.bg:SetAllPoints()
    swatch.bg:SetColorTexture(0.2, 0.2, 0.2, 1)
    swatch.color = swatch:CreateTexture(nil, "ARTWORK")
    swatch.color:SetPoint("TOPLEFT", 2, -2)
    swatch.color:SetPoint("BOTTOMRIGHT", -2, 2)
    local hint = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    hint:SetPoint("LEFT", swatch, "RIGHT", 6, 0)
    hint:SetText("(click to change)")
    hint:SetTextColor(0.6, 0.6, 0.6)
    swatch.refresh = function()
        local color = colorProvider()
        swatch.color:SetColorTexture(color.r, color.g, color.b, 1)
    end
    swatch:SetScript("OnClick", function()
        local color = colorProvider()
        ColorPickerFrame:SetupColorPickerAndShow({
            r = color.r, g = color.g, b = color.b,
            swatchFunc = function()
                color.r, color.g, color.b = ColorPickerFrame:GetColorRGB()
                swatch.refresh()
                changed()
            end,
            cancelFunc = function(previous)
                color.r, color.g, color.b = previous.r, previous.g, previous.b
                swatch.refresh()
                changed()
            end,
        })
    end)
    return swatch
end

local function CreateEditControl(parent, labelText, x, y, width, getter, setter)
    local label = CreateText(parent, labelText, x, y, "GameFontNormal")
    local edit = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    edit:SetSize(width, 22)
    edit:SetPoint("LEFT", label, "RIGHT", 8, 0)
    edit:SetAutoFocus(false)
    edit:SetScript("OnEnterPressed", function(self)
        setter(self:GetText())
        self:ClearFocus()
    end)
    edit:SetScript("OnEditFocusLost", function(self) setter(self:GetText()) end)
    edit.refresh = function() edit:SetText(getter() or "") end
    return edit
end

local function CreatePresetRow(parent, x, y, settingsProvider, changed)
    local label = CreateText(parent, "Presets:", x, y, "GameFontNormal")
    local buttons = {}
    for index, preset in ipairs(PRESETS) do
        local button = CreateFrame("Button", nil, parent)
        button:SetSize(34, 18)
        if index == 1 then
            button:SetPoint("LEFT", label, "RIGHT", 8, 0)
        else
            button:SetPoint("LEFT", buttons[index - 1], "RIGHT", 4, 0)
        end
        local border = button:CreateTexture(nil, "BACKGROUND")
        border:SetAllPoints()
        border:SetColorTexture(0.35, 0.35, 0.35, 1)
        local fill = button:CreateTexture(nil, "ARTWORK")
        fill:SetPoint("TOPLEFT", 2, -2)
        fill:SetPoint("BOTTOMRIGHT", -2, 2)
        fill:SetColorTexture(preset[1], preset[2], preset[3], 1)
        button:SetScript("OnClick", function()
            local settings = settingsProvider()
            settings.color.r, settings.color.g, settings.color.b = preset[1], preset[2], preset[3]
            changed()
        end)
        buttons[index] = button
    end
    return buttons
end


local function Button(parent, label, x, y, width, callback)
    local button = CreateFrame("Button",nil,parent,"BackdropTemplate")
    button:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
    button:SetNormalFontObject("GameFontHighlight")
    button:SetHighlightFontObject("GameFontNormal")
    button:SetDisabledFontObject("GameFontDisable")
    themedButtons[#themedButtons+1]=button
    button:SetScript("OnEnter",function(self) if self.palette then self:SetBackdropBorderColor(unpack(self.palette.accent)) end end)
    button:SetScript("OnLeave",function(self) if self.palette then self:SetBackdropBorderColor(unpack(self.palette.border)) end end)
    button:SetSize(width,26); button:SetPoint("TOPLEFT",x,y); button:SetText(label)
    button:SetScript("OnClick",callback)
    return button
end
function addon:OpenStandaloneSettings()
    if InCombatLockdown() then print("Shaman Assist: Open settings after combat."); return end
    if not self.settingsWindow then self:BuildSettingsWindow() end
    self.settingsWindow:Show()
    self.settingsWindow:Refresh()
end
function addon:BuildSettingsWindow()
    local window=CreateFrame("Frame","ShamanAssistSettingsWindow",UIParent,"BackdropTemplate")
    window:SetSize(960,670); window:SetPoint("CENTER"); window:SetFrameStrata("DIALOG")
    local scale=math.min(1,(UIParent:GetWidth()-40)/960,(UIParent:GetHeight()-40)/670)
    window:SetScale(math.max(0.5,scale)); window:SetClampedToScreen(true)
    window:EnableMouse(true); window:SetMovable(true); window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart",function(self) self:StartMoving() end)
    window:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
    window:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
    local brand=window:CreateTexture(nil,"ARTWORK")
    brand:SetSize(42,42); brand:SetPoint("TOPLEFT",20,-17); brand:SetTexture(self.icon)
    local title=CreateText(window,"Shaman Assist",74,-20,"GameFontNormalLarge")
    local specLabel=CreateText(window,"",74,-45,"GameFontHighlightSmall",nil,{.55,.7,.85})
    window.testAllButton=Button(window,"Test All",635,-25,140,function() addon:TestAlert() end)
    window.stopTestButton=Button(window,"Stop Test",785,-25,120,function() addon:StopTest() end)
    local close=Button(window,"X",930,-5,24,function() window:Hide() end)
    window.editLayoutButton=Button(window,"Edit Layout",475,-25,145,function() addon:StartLayoutEdit() end)
    local toolbar=CreateFrame("Frame",nil,UIParent,"BackdropTemplate")
    toolbar:SetSize(430,70);toolbar:SetPoint("TOP",UIParent,"TOP",0,-30);toolbar:SetFrameStrata("TOOLTIP")
    toolbar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
    CreateText(toolbar,"Drag icons, text and timelines, then save.",15,-10,"GameFontHighlight")
    toolbar.saveButton=Button(toolbar,"Save positions",15,-35,190,function() addon:FinishLayoutEdit(true);addon:OpenStandaloneSettings() end)
    toolbar.cancelButton=Button(toolbar,"Cancel",220,-35,190,function() addon:FinishLayoutEdit(false);addon:OpenStandaloneSettings() end)
    addon.layoutToolbar=toolbar;toolbar:Hide()
    table.insert(UISpecialFrames,"ShamanAssistSettingsWindow")
    activeStandalonePanel=window
    local pages, nav, cards, controls={},{},{},{}
    local current="general"
    local function Add(control) controls[#controls+1]=control; return control end
    local function Changed() addon:ApplySettings(); window:Refresh() end
    local function Card(parent,label,x,y,width,height)
        local card=CreateCard(parent,label); card:SetPoint("TOPLEFT",x,y); card:SetSize(width,height)
        cards[#cards+1]=card; return card
    end
    local function Page(key)
        local page=CreateFrame("Frame",nil,window); page:SetPoint("TOPLEFT",220,-80); page:SetSize(718,540)
        pages[key]=page; page:Hide(); return page
    end
    local function Check(parent,label,y,s,field)
        Add(CreateCheck(parent,label,12,y,function() return s[field] end,function(value) s[field]=value; Changed() end))
    end
    local general=Page("general")
    local main=Card(general,"General",0,0,718,190)
    Check(main,"Enable Shaman Assist",-35,ShamanAssistDB,"enabled")
    Add(CreateCheck(main,"Lock icon and text positions",12,-70,function() return ShamanAssistDB.locked end,function(v)
        ShamanAssistDB.locked=v; Changed(); if not v then addon:TestAlert() end
    end))
    Add(CreateCheck(main,"Show minimap button",12,-105,function() return not ShamanAssistDB.minimapHidden end,function(v)
        addon:SetMinimapButtonShown(v); window:Refresh()
    end))
    CreateText(main,"Window theme",365,-42)
    Add(CreateDropdown(main,345,-65,230,function() return THEME_ITEMS end,function() return ShamanAssistDB.standaloneTheme end,function(v)
        ShamanAssistDB.standaloneTheme=v; window:Refresh()
    end))
    CreateText(main,"Specialization (settings & preview)",365,-110)
    Add(CreateDropdown(main,345,-133,230,function() return {
        {text="Auto",value="auto"},{text="Enhancement",value="263"},
        {text="Elemental",value="262"},{text="Restoration",value="264"},
    } end,function() return ShamanAssistDB.specView end,function(v) addon:SetSpecView(v) end))
    local about=Card(general,"Getting started",0,-210,718,300)
    CreateText(about,"1. Choose an alert on the left.\n2. Enable its icon, text, or action-button glow.\n3. Test the alert; unlock positions to drag the icon and text.\n4. Lock positions when finished.",20,-40,"GameFontHighlight",665,{.78,.85,.94})
    CreateText(about,"Maelstrom Weapon uses a configurable stack threshold (default: 10).\nProc alerts follow Blizzard's proc signal or a readable player aura.\nImbue reminders check for any temporary weapon enchant; they do not verify its type.\n\nUnavailable combat aura data shows '?' rather than a guessed stack count.\nA missing buff is never inferred from unavailable combat data.",20,-140,"GameFontHighlightSmall",665,{.65,.75,.86})
    Button(about,"Rescan buttons / CDM",20,-250,200,function() addon:RequestScan() end)
    Button(about,"Reset display positions",240,-250,200,function() addon:ResetPositions() end)
    Button(about,"Print status",460,-250,180,function() addon:PrintStatus() end)

    local glowItems={}
    for _, item in ipairs(self.GLOW_TYPES) do glowItems[#glowItems+1]={text=item.name,value=item.id} end
    for _, key in ipairs(self.order) do
        local info,s=self.info[key],ShamanAssistDB.alerts[key]
        local page=Page(key)
        local behavior=Card(page,"Display & tracking",0,0,344,405)
        Check(behavior,"Enable this alert",-34,s,"enabled")
        Check(behavior,"Show icon",-67,s,"iconEnabled")
        Check(behavior,"Show text alert",-100,s,"textEnabled")
        Check(behavior,"Only show during combat",-133,s,"combatOnly")
        Check(behavior,"Glow on action buttons",-166,s,"actionGlow")
        Check(behavior,"Glow on Cooldown Manager",-199,s,"cdmGlow")
        Check(behavior,"Play sound when alert starts",-232,s,"sound")
        if key=="maelstrom" then
            Add(CreateSlider(behavior,"Alert at stacks",20,-283,232,1,10,1,function() return s.threshold end,function(v) s.threshold=math.floor(v+.5); Changed() end))
            Check(behavior,"Show stack bar",-336,s,"barEnabled")
            Check(behavior,"Keep zero stacks visible",-369,s,"alwaysShow")
        elseif info.kind=="activeBuff" then
            Check(behavior,"Show timeline",-268,s,"timelineEnabled")
            Check(behavior,"Show remaining time",-301,s,"durationText")
            Check(behavior,"Show buff stacks",-334,s,"showStacks")
            CreateText(behavior,info.hero and (addon.heroNames[info.hero].." - actual buff / totem only") or "Drag the timeline while positions are unlocked.",20,-378,"GameFontHighlightSmall",302,{.65,.75,.85})
        else
            local note=info.kind=="proc" and "The icon appears when Blizzard highlights this ability or its tracked proc aura is readable. No rotation is simulated."
                or info.kind=="enchant" and "Warns when the equipped weapon has no temporary enchant. Any temporary enchant satisfies this reminder."
                or key=="crashLightning" and "Glows while the buff is confirmed missing. Add Crash Lightning to Blizzard Tracked Buffs for combat fallback. No target-count or cooldown check."
                or "Warns when Lightning Shield is confirmed missing. In combat, unavailable buff data suppresses the reminder."
            CreateText(behavior,note,20,-287,"GameFontHighlightSmall",302,{.65,.75,.85})
        end
        local style=Card(page,"Glow & appearance",362,0,356,405)
        CreateText(style,"Glow style",20,-43)
        Add(CreateDropdown(style,0,-65,270,function() return glowItems end,function() return s.glowType end,function(v) s.glowType=v; Changed() end))
        Add(CreateColorControl(style,20,-113,"Color",function() return s.color end,Changed))
        CreatePresetRow(style,20,-147,function() return s end,Changed)
        Add(CreateSlider(style,"Opacity",20,-185,240,.1,1,.05,function() return s.alpha end,function(v) s.alpha=v; Changed() end))
        Add(CreateSlider(style,"Icon size",20,-240,240,24,96,1,function() return s.size end,function(v) s.size=math.floor(v+.5); Changed() end))
        Add(CreateSlider(style,"Glow speed",20,-295,240,.05,1,.05,function() return s.speed end,function(v) s.speed=v; Changed() end))
        if info.kind=="activeBuff" then
            Add(CreateSlider(style,"Timeline width",20,-350,240,160,500,10,function() return s.timelineWidth end,function(v) s.timelineWidth=v; Changed() end))
        else
            Add(CreateSlider(style,"Border thickness",20,-350,240,1,6,1,function() return s.thickness end,function(v) s.thickness=math.floor(v+.5); Changed() end))
        end
        local text=Card(page,"Text alert",0,-420,718,112)
        Add(CreateEditControl(text,"Text",20,-42,405,function() return s.text end,function(v) s.text=v; addon:ApplySettings() end))
        Add(CreateSlider(text,"Text size",510,-36,120,12,48,1,function() return s.fontSize end,function(v) s.fontSize=math.floor(v+.5); Changed() end))
        Button(text,"Test alert",20,-76,130,function() addon:TestAlert(key) end)
        Button(text,"Reset position",165,-76,140,function() addon:ResetPositions(key) end)
        Button(text,"Unlock & move",320,-76,140,function() ShamanAssistDB.locked=false; Changed(); addon:TestAlert(key) end)
        Button(text,"Lock",475,-76,90,function() ShamanAssistDB.locked=true; addon:StopTest(); Changed() end)
    end
    local navigation={{key="general",name="General"}}
    for _, key in ipairs(self.order) do navigation[#navigation+1]={key=key,name=self.info[key].name} end
    for index, item in ipairs(navigation) do
        local key=item.key
        local b=Button(window,item.name,18,-85-(index-1)*39,184,function() current=key; window:Refresh() end)
        nav[key]=b
    end
    local footer=CreateText(window,"",22,-636,"GameFontHighlightSmall",910,{.55,.68,.8})
    local navPage,navSpec=1,nil
    local previous=Button(window,"< Previous",18,-590,90,function() navPage=navPage-1;window:Refresh() end)
    local nextPage=Button(window,"Next >",112,-590,90,function() navPage=navPage+1;window:Refresh() end)
    local pageLabel=CreateText(window,"",24,-565,"GameFontHighlightSmall")
    window.navPrevious=previous;window.navNext=nextPage;window.navButtons=nav
    function window:Refresh()
        local selectedName=addon.specNames[addon:GetSelectedSpec()] or "Shaman"
        specLabel:SetText(selectedName.."  /  "..addon.version.."  /  "..(ShamanAssistDB.specView=="auto" and "Auto" or "Manual"))
        if current~="general" and not addon:IsSelectedAlert(current) then current="general" end
        local p=STANDALONE_THEMES[ShamanAssistDB.standaloneTheme] or STANDALONE_THEMES.frosted
        self:SetBackdropColor(unpack(p.window)); self:SetBackdropBorderColor(unpack(p.border))
        toolbar:SetBackdropColor(p.panel[1],p.panel[2],p.panel[3],1);toolbar:SetBackdropBorderColor(unpack(p.border))
        for _,label in ipairs(themedLabels) do label:SetTextColor(unpack(p.text)) end
        for _,b in ipairs(themedButtons) do
            b.palette=p;b:SetBackdropColor(p.control[1],p.control[2],p.control[3],1)
            b:SetBackdropBorderColor(unpack(p.border))
            local fs=b:GetFontString();if fs then fs:SetTextColor(unpack(p.text)) end
        end
        for _,c in ipairs(themedChecks) do
            local texture=c:GetCheckedTexture();if texture then texture:SetVertexColor(unpack(p.accent)) end
        end
        title:SetTextColor(unpack(p.accent))
        for _, card in ipairs(cards) do
            card:SetBackdropColor(p.card[1],p.card[2],p.card[3],1)
            card:SetBackdropBorderColor(p.border[1],p.border[2],p.border[3],1)
            card.title:SetTextColor(unpack(p.accent))
            card.leftDivider:SetVertexColor(unpack(p.accent));card.rightDivider:SetVertexColor(unpack(p.accent))
        end
        for key,page in pairs(pages) do page:SetShown(key==current) end
        local positions={general=0}
        local selectedSpec=addon:GetSelectedSpec()
        if navSpec~=selectedSpec then navPage=1;navSpec=selectedSpec end
        local list=addon.specOrders[selectedSpec] or {}
        local count=math.max(1,math.ceil(#list/11))
        navPage=math.max(1,math.min(navPage,count))
        for i=(navPage-1)*11+1,math.min(navPage*11,#list) do positions[list[i]]=i-(navPage-1)*11 end
        previous:SetShown(count>1);nextPage:SetShown(count>1)
        if navPage==1 then previous:Disable() else previous:Enable() end
        if navPage==count then nextPage:Disable() else nextPage:Enable() end
        pageLabel:SetText("Alerts "..navPage.." / "..count)
        for key,b in pairs(nav) do
            b:SetShown(positions[key]~=nil)
            if positions[key] then b:ClearAllPoints();b:SetPoint("TOPLEFT",18,-85-positions[key]*39) end
            if key==current then b:Disable();b:SetBackdropBorderColor(unpack(p.accent));b:SetBackdropColor(unpack(p.panel)) else b:Enable() end
        end
        for _,control in ipairs(controls) do if control.refresh then control.refresh() end end
        for _,dd in ipairs(self.shamanassistModernDropdowns or {}) do dd:SetModernMode(ShamanAssistDB.standaloneTheme~="classic",p) end
        footer:SetText("Playing: "..(addon.specName or "Shaman").." / "..(addon.heroNames[addon.heroID] or "Hero not detected").."   |   Editing: "..selectedName.."   |   "..(ShamanAssistDB.locked and "Positions locked" or "Positions unlocked"))
    end
    window:SetScript("OnHide",function()
        addon:StopTest()
        for _, dd in ipairs(window.shamanassistModernDropdowns or {}) do if dd.menu then dd.menu:Hide() end end
    end)
    self.settingsWindow=window
    activeStandalonePanel=nil
    window:Refresh()
end
function addon:RegisterSettings()
    if self.settingsCategory or not Settings or not Settings.RegisterCanvasLayoutCategory then return end
    local panel=CreateFrame("Frame"); panel.name="Shaman Assist"
    CreateText(panel,"Shaman Assist - All specializations",20,-20,"GameFontNormalLarge")
    CreateText(panel,"Automatic Enhancement, Elemental and Restoration alerts.",20,-53,"GameFontHighlight")
    Button(panel,"Open Shaman Assist",20,-90,220,function() addon:OpenStandaloneSettings() end)
    self.settingsCategory=Settings.RegisterCanvasLayoutCategory(panel,panel.name)
    Settings.RegisterAddOnCategory(self.settingsCategory)
end

