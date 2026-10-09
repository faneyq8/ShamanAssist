local addonName, addon = ...
ShamanAssist = addon
addon.version = "0.3.0-beta.1"
addon.icon = "Interface\\AddOns\\ShamanAssist\\Media\\ShamanAssistIcon.tga"
addon.order = { "maelstrom", "stormstrike", "hotHand", "tempest", "lightningShield", "mainHand", "offHand", "crashLightning", "tempestBuff", "ascendance", "doomWinds" }
addon.info = {
    maelstrom = { name = "Maelstrom Weapon", aura = 344179, icon = 344179, spells = { 403, 188196, 421, 188443, 452201 }, text = "MAELSTROM READY", kind = "stacks" },
    stormstrike = { name = "Stormstrike Proc", aura = 201846, icon = 17364, spells = { 17364, 115356 }, text = "STORMSTRIKE", kind = "proc" },
    hotHand = { name = "Hot Hand / Lava Lash", aura = 215785, icon = 60103, spells = { 60103 }, text = "LAVA LASH", kind = "proc" },
    tempest = { name = "Tempest", aura = 454015, icon = 452201, spells = { 452201 }, text = "TEMPEST", kind = "proc" },
    tempestBuff = { name = "Tempest Buff", aura = 454015, icon = 452201, spells = {452201}, text = "TEMPEST BUFF", kind = "activeBuff" },
    ascendance = { name = "Ascendance", aura = 114051, icon = 114051, spells = {114051}, text = "ASCENDANCE", kind = "activeBuff" },
    doomWinds = { name = "Doom Winds", aura = 466772, icon = 384352, texture = "Interface\\Icons\\Ability_IronMaidens_SwirlingVortex", spells = {384352}, text = "DOOM WINDS", kind = "activeBuff" },
    crashLightning = { name = "Crash Lightning", aura = 187878, auras = {187878,1252415}, icon = 187874, spells = {187874}, text = "CRASH LIGHTNING MISSING", kind = "buff" },
    lightningShield = { name = "Lightning Shield", aura = 192106, icon = 192106, spells = { 192106 }, text = "LIGHTNING SHIELD MISSING", kind = "buff" },
    mainHand = { name = "Main-hand Imbue", icon = 33757, spells = { 33757 }, text = "MAIN-HAND IMBUE MISSING", slot = 16, kind = "enchant" },
    offHand = { name = "Off-hand Imbue", icon = 318038, spells = { 318038 }, text = "OFF-HAND IMBUE MISSING", slot = 17, kind = "enchant" },
}
addon.specNames = {[262]="Elemental",[263]="Enhancement",[264]="Restoration"}
addon.specOrders = {[263]=CopyTable(addon.order),[262]={"eleLavaSurge","eleTempest","eleAscendance","eleLightningShield","eleImbue"},
    [264]={"restoTidalWaves","restoAscendance","restoWaterShield","restoEarthShield","restoImbue"}}
for _,key in ipairs(addon.order) do addon.info[key].spec=263 end
local newAlerts={
    eleLavaSurge={name="Lava Surge",aura=77762,icon=51505,spells={51505},text="LAVA SURGE",kind="proc"},
    eleTempest={name="Tempest Buff",aura=454015,icon=452201,spells={452201},text="TEMPEST",kind="activeBuff"},
    eleAscendance={name="Ascendance",aura=114050,icon=114050,spells={114050},text="ASCENDANCE",kind="activeBuff"},
    eleLightningShield={name="Lightning Shield",aura=192106,icon=192106,spells={192106},text="LIGHTNING SHIELD MISSING",kind="buff"},
    eleImbue={name="Flametongue Imbue",icon=318038,spells={318038},slot=16,text="MAIN-HAND IMBUE MISSING",kind="enchant"},
    restoTidalWaves={name="Tidal Waves",aura=53390,icon=53390,spells={53390},text="TIDAL WAVES",kind="activeBuff"},
    restoAscendance={name="Ascendance",aura=114052,icon=114052,spells={114052},text="ASCENDANCE",kind="activeBuff"},
    restoWaterShield={name="Water Shield",aura=52127,icon=52127,spells={52127},text="WATER SHIELD MISSING",kind="buff"},
    restoEarthShield={name="Earth Shield (self)",aura=974,icon=974,spells={974},text="EARTH SHIELD",kind="activeBuff"},
    restoImbue={name="Earthliving Imbue",icon=382021,spells={382021},slot=16,text="EARTHLIVING IMBUE MISSING",kind="enchant"},
}
for _,spec in ipairs({262,264}) do
    for _,key in ipairs(addon.specOrders[spec]) do
        addon.info[key]=newAlerts[key];addon.info[key].spec=spec
        addon.order[#addon.order+1]=key
    end
end
addon:RegisterHeroAlerts()
function addon:IsCurrentAlert(key) return self.info[key] and self.info[key].spec==self.specID end
function addon:GetSelectedSpec()
    local choice=ShamanAssistDB and ShamanAssistDB.specView
    return choice~="auto" and self.specNames[tonumber(choice)] and tonumber(choice) or self.specID
end
function addon:IsSelectedAlert(key) return self.info[key] and self.info[key].spec==self:GetSelectedSpec() end
function addon:SetSpecView(choice)
    if choice~="auto" and not self.specNames[tonumber(choice)] then return end
    if self.layoutEditing then self:FinishLayoutEdit(false) end
    self:StopTest()
    ShamanAssistDB.specView=choice
    if self.settingsWindow then self.settingsWindow:Refresh() end
end
addon.defaults = {
    enabled = true, locked = true, standaloneTheme = "frosted", minimapHidden = false, specView = "auto",
    minimapAngle = 225, schema = 1, alerts = {},
}
for index, key in ipairs(addon.order) do
    local info = addon.info[key]
    local reminder = info.kind == "buff" or info.kind == "enchant"
    addon.defaults.alerts[key] = {
        enabled = true, iconEnabled = true, textEnabled = false, sound = false,
        combatOnly = not reminder, actionGlow = not reminder, cdmGlow = false,
        glowType = "pixel", color = reminder and {r=1,g=0.35,b=0.15} or {r=0.25,g=0.70,b=1},
        alpha = 1, speed = 0.25, lines = 8, thickness = 2, particles = 4, scale = 1,
        size = 48, fontSize = 23, text = info.text, threshold = 10,
        barEnabled = key == "maelstrom", alwaysShow = false,
        timelineEnabled = key == "ascendance", durationText = true, showStacks = true,
        timelineWidth = 280, timelineHeight = 24,
        timelinePoint = {"CENTER","CENTER",0,-290},
        point = { "CENTER", "CENTER", (index - 4) * 62, -135 },
        textPoint = { "CENTER", "CENTER", 0, 180 - index * 32 },
    }
end
for _,spec in ipairs({262,264}) do
    for i,key in ipairs(addon.specOrders[spec]) do
        local s=addon.defaults.alerts[key]
        s.point={"CENTER","CENTER",(i-3)*64,-135}
        s.textPoint={"CENTER","CENTER",0,180-i*36}
        s.timelinePoint={"CENTER","CENTER",0,-240-i*32}
        if addon.info[key].kind=="activeBuff" then s.combatOnly=false;s.actionGlow=false end
        s.timelineEnabled=key=="eleAscendance" or key=="restoAscendance"
    end
end
addon.defaults.alerts.crashLightning.combatOnly = true
for _,spec in ipairs({262,263,264}) do
    local index=0
    for _,key in ipairs(addon.specOrders[spec]) do
        if addon.info[key].heroAdded then
            local s=addon.defaults.alerts[key]
            s.combatOnly=false;s.actionGlow=false
            s.point={"CENTER","CENTER",(index%6-2.5)*68,80-math.floor(index/6)*76}
            s.textPoint={"CENTER","CENTER",350,220-index*28}
            s.timelinePoint={"CENTER","CENTER",-330,220-index*28}
            s.timelineEnabled=addon.info[key].totemSpell~=nil or key:find("Ancestors")~=nil
            index=index+1
        end
    end
end
addon.defaults.alerts.crashLightning.actionGlow = true
for i,key in ipairs({"tempestBuff","ascendance","doomWinds"}) do
    local s=addon.defaults.alerts[key]
    s.combatOnly=false; s.actionGlow=false
    s.point={"CENTER","CENTER",(i-2)*64,-225}
    s.textPoint={"CENTER","CENTER",320,120-(i-1)*36}
    s.timelinePoint={"CENTER","CENTER",0,-290-(i-1)*40}
end
addon.states, addon.overlay, addon.known = {}, {}, {}
for _, key in ipairs(addon.order) do addon.states[key] = { active = false, status = "Not initialized" } end

function addon:IsSecret(value)
    return issecretvalue and issecretvalue(value) or false
end
function addon:Public(value, kind)
    if self:IsSecret(value) then return nil end
    if kind and type(value) ~= kind then return nil end
    return value
end
function addon:SafeCall(fn, ...)
    if type(fn) ~= "function" then return nil, false end
    local ok, value = pcall(fn, ...)
    if not ok or self:IsSecret(value) then return nil, false end
    return value, true
end
local function Merge(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then target[key] = {} end
            Merge(target[key], value)
        elseif type(target[key]) ~= type(value) then target[key] = value end
    end
end
function addon:InitializeDB()
    if type(ShamanAssistDB) ~= "table" then ShamanAssistDB = {} end
    Merge(ShamanAssistDB, self.defaults)
    for _, settings in pairs(ShamanAssistDB.alerts) do
        if type(settings) == "table" then
            for _, name in ipairs({ "threshold", "size", "fontSize", "alpha", "speed", "lines", "thickness" }) do
                local limits = { threshold={1,10}, size={24,96}, fontSize={12,48}, alpha={0.1,1}, speed={0.05,1}, lines={1,16}, thickness={1,6} }
                local range = limits[name]
                if type(settings[name]) == "number" then settings[name] = math.max(range[1], math.min(range[2], settings[name])) end
            end
        end
    end
end
function addon:UpdateSpec()
    local _, class = UnitClass("player")
    local api = C_SpecializationInfo
    local spec = self:SafeCall(api and api.GetSpecialization or GetSpecialization)
    local specID = spec and self:SafeCall(api and api.GetSpecializationInfo or GetSpecializationInfo, spec)
    specID=class=="SHAMAN" and self.specNames[specID] and specID or nil
    if self.specID~=specID then
        if self.layoutEditing then self:FinishLayoutEdit(false) end
        self.testKey=nil;self.testGeneration=(self.testGeneration or 0)+1;self.overlay={}
    end
    self.specID=specID
    self.specName=self.specNames[specID] or "No specialization"
    self.isSupported=specID~=nil
    self:UpdateHeroSpec()
    self.isEnhancement = class == "SHAMAN" and specID == 263 or false
    if not InCombatLockdown() then
        for _, info in pairs(self.info) do
            for _, id in ipairs(info.spells) do
                local fn = C_SpellBook and C_SpellBook.IsSpellKnownOrInSpellBook or IsPlayerSpell
                local known = self:SafeCall(fn, id)
                self.known[id] = known == true
            end
        end
    end
    if self.settingsWindow then self.settingsWindow:Refresh() end
end
function addon:ReadAura(id)
    local aura, readable = self:SafeCall(C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID, id)
    if not readable then return nil, false end
    -- A nil restricted aura is not proof that a buff is missing in combat.
    if aura == nil then
        local restricted, ok = self:SafeCall(C_Secrets and C_Secrets.ShouldSpellAuraBeSecret, id)
        if ok and type(restricted)=="boolean" then return nil, not restricted end
        return nil, not InCombatLockdown()
    end
    if type(aura) ~= "table" then return nil, false end
    return aura, true
end
function addon:ReadCrashLightningMissing()
    local allReadable = true
    for _, id in ipairs(self.info.crashLightning.auras) do
        local aura, readable = self:ReadAura(id)
        if aura then return false, "Buff present" end
        if not readable then allReadable = false end
    end
    if allReadable then return true, "Buff missing" end
    -- Only actual Tracked Buff items can establish absence. A spell's
    -- cooldown state or an icon's visibility is not a buff-presence signal.
    local readable = false
    for frame, entry in pairs(self.external or {}) do
        if entry.valid and entry.buffSource and entry.keys.crashLightning then
            local active, ok = self:SafeCall(frame.IsActive, frame)
            if ok and type(active)=="boolean" then
                if active then return false, "Tracked Buff present" end
                readable = true
            end
        end
    end
    if readable then return true, "Tracked Buff missing" end
    return false, "Buff unavailable: add Crash Lightning to Tracked Buffs"
end
function addon:ReadEnchant(slot)
    local item, itemOK = self:SafeCall(GetInventoryItemID, "player", slot)
    if not itemOK then return nil end
    if not item then return false end -- No equipped item: no imbue reminder.
    if C_PaperDollInfo and C_PaperDollInfo.GetTemporaryEnchantmentInfo then
        local enchant, ok = self:SafeCall(C_PaperDollInfo.GetTemporaryEnchantmentInfo, slot)
        if not ok then return nil end
        return enchant == nil
    end
    -- Compatibility with clients preceding the per-slot API.
    if GetWeaponEnchantInfo then
        local ok, main, _, _, _, off = pcall(GetWeaponEnchantInfo)
        if not ok then return nil end
        local value
        if slot == 16 then value = main else value = off end
        if self:IsSecret(value) then return nil end
        return not value
    end
    return nil
end
function addon:ReadProc(info)
    for _, id in ipairs(info.spells) do
        local value, ok = self:SafeCall(C_SpellActivationOverlay and C_SpellActivationOverlay.IsSpellOverlayed, id)
        if ok and type(value) == "boolean" then self.overlay[id] = value end
        if self.overlay[id] then return true, "Blizzard proc" end
    end
    local aura, readable = self:ReadAura(info.aura)
    if aura then return true, "Player aura" end
    return false, readable and "Inactive" or "No readable proc"
end
function addon:RefreshState()
    if not ShamanAssistDB then return end
    local usable = ShamanAssistDB.enabled and self.isSupported
    local dead = UnitIsDeadOrGhost("player")
    local mounted = IsMounted()
    usable = usable and not dead and not mounted
    for _, key in ipairs(self.order) do
        local info, state, settings = self.info[key], self.states[key], ShamanAssistDB.alerts[key]
        state.active, state.count, state.aura = false, nil, nil
        state.durationObject, state.expiration, state.totalDuration = nil, nil, nil
        state.status = not self:IsCurrentAlert(key) and "Inactive specialization" or "Disabled"
        if usable and self:IsCurrentAlert(key) and self:IsHeroEligible(info) and settings.enabled then
            if info.kind == "stacks" then
                local aura, readable = self:ReadAura(info.aura)
                state.aura = aura
                if aura then state.count = self:Public(aura.applications, "number")
                elseif readable then state.count = 0 end
                state.active = state.count ~= nil and state.count >= settings.threshold
                state.status = state.count ~= nil and "Player aura" or "Stack count unavailable"
            elseif info.kind == "proc" then
                state.active, state.status = self:ReadProc(info)
            elseif info.kind == "activeBuff" then
                self:ReadBuffTracker(key, state)
            elseif info.kind == "buff" then
                if key == "crashLightning" then
                    state.active, state.status = self:ReadCrashLightningMissing()
                    state.active = self.known[info.spells[1]] and state.active or false
                else
                    local aura, readable = self:ReadAura(info.aura)
                    state.active = self.known[info.spells[1]] and readable and not aura or false
                    state.status = aura and "Present" or (readable and "Missing" or "Buff state unavailable")
                end
            elseif info.kind == "enchant" then
                local missing = self:ReadEnchant(info.slot)
                state.active = self.known[info.spells[1]] and missing == true or false
                state.status = missing == nil and "Imbue state unavailable" or (missing and "Missing" or "Present / no weapon")
            end
            if settings.combatOnly and not InCombatLockdown() then state.active = false end
        end
        state.visible = usable and self:IsCurrentAlert(key) and self:IsHeroEligible(info) and settings.enabled and (not settings.combatOnly or InCombatLockdown()) or false
        self:RenderAlert(key)
    end
    if self.UpdateExternalGlows then self:UpdateExternalGlows() end
end
function addon:ApplySettings()
    if not ShamanAssistDB then return end
    if self.ApplyDisplaySettings then self:ApplyDisplaySettings() end
    self:RefreshState()
    if self.RequestScan then self:RequestScan() end
end
function addon:TestAlert(key)
    if self.layoutEditing then return end
    if not self.isSupported or (key and not self:IsSelectedAlert(key)) then return end
    self.testKey = key or "all"
    self.testStartedAt = GetTime()
    self.testEndsAt = self.testStartedAt + (self.testKey == "all" and 20 or 6)
    self.testGeneration = (self.testGeneration or 0) + 1
    local generation = self.testGeneration
    self:RefreshState()
    C_Timer.After(self.testKey == "all" and 20 or 6, function()
        if self.testGeneration == generation then self:StopTest() end
    end)
end
function addon:StopTest()
    if self.layoutEditing then return end
    self.testKey = nil
    self.testGeneration = (self.testGeneration or 0) + 1
    self:RefreshState()
end
function addon:IsTesting(key) return self:IsSelectedAlert(key) and (self.testKey == "all" or self.testKey == key) end
function addon:StartLayoutEdit()
    if InCombatLockdown() or self.layoutEditing or not self.isSupported then return end
    if self.settingsWindow then self.settingsWindow:Hide() end
    self.layoutSnapshot=CopyTable(ShamanAssistDB.alerts)
    self.layoutWasLocked=ShamanAssistDB.locked
    self.layoutEditing=true
    ShamanAssistDB.locked=false
    self.testGeneration=(self.testGeneration or 0)+1
    self.testKey="all";self.testStartedAt=GetTime();self.testEndsAt=GetTime()+20
    self:ApplySettings()
    self.layoutToolbar:Show()
end
function addon:FinishLayoutEdit(save)
    if not self.layoutEditing then return end
    for _,key in ipairs(self.order) do
        local d=self.displays[key]
        for _,f in ipairs({d.icon,d.text,d.timeline}) do f:StopMovingOrSizing() end
        if not save then
            for _,field in ipairs({"point","textPoint","timelinePoint"}) do
                ShamanAssistDB.alerts[key][field]=CopyTable(self.layoutSnapshot[key][field])
            end
        end
    end
    self.layoutEditing=false;self.layoutSnapshot=nil
    ShamanAssistDB.locked=save or self.layoutWasLocked
    self.layoutToolbar:Hide();self:StopTest();self:ApplySettings()
end
function addon:ResetPositions(key)
    for _, name in ipairs(self.order) do
        if (not key and self:IsSelectedAlert(name)) or key == name then
            ShamanAssistDB.alerts[name].point = CopyTable(self.defaults.alerts[name].point)
            ShamanAssistDB.alerts[name].textPoint = CopyTable(self.defaults.alerts[name].textPoint)
            ShamanAssistDB.alerts[name].timelinePoint = CopyTable(self.defaults.alerts[name].timelinePoint)
        end
    end
    self:ApplySettings()
end
function addon:PrintStatus()
    print("|cff4da3ffShaman Assist " .. self.version .. "|r - " .. self.specName)
    for _, key in ipairs(self.order) do
        local s = self.states[key]
        print(self.info[key].name .. ": " .. s.status .. (s.count ~= nil and (" (" .. s.count .. ")") or ""))
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({ "ADDON_LOADED", "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "PLAYER_SPECIALIZATION_CHANGED",
    "PLAYER_TALENT_UPDATE", "SPELLS_CHANGED", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_DEAD", "PLAYER_ALIVE",
    "PLAYER_UNGHOST", "PLAYER_TOTEM_UPDATE", "TRAIT_CONFIG_UPDATED", "PLAYER_MOUNT_DISPLAY_CHANGED", "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" }) do events:RegisterEvent(event) end
events:RegisterUnitEvent("UNIT_AURA", "player")
events:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
events:SetScript("OnEvent", function(_, event, arg)
    if event == "ADDON_LOADED" then
        if arg == addonName then addon:InitializeDB() end
        return
    end
    if not ShamanAssistDB then addon:InitializeDB() end
    if event == "PLAYER_LOGIN" then
        addon:UpdateSpec(); addon:CreateDisplays(); addon:ApplySettings(); addon:RegisterSettings()
        -- Lightweight upkeep refresh outside combat; no repeated frame scans.
        C_Timer.NewTicker(3, function()
            if addon.isSupported and not InCombatLockdown() and ShamanAssistDB.enabled then addon:RefreshState() end
        end)
        return
    end
    if not addon.displays then return end
    if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" or event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        arg = addon:Public(arg, "number")
        if not arg then return end
        addon.overlay[arg] = event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "TRAIT_CONFIG_UPDATED" or event == "SPELLS_CHANGED"
        or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
        addon.overlay = {}
        addon:UpdateSpec()
        if addon.RequestScan then addon:RequestScan() end
    elseif event == "PLAYER_REGEN_DISABLED" then
        addon:FinishLayoutEdit(false)
        addon.testKey = nil
        if addon.settingsWindow then addon.settingsWindow:Hide() end
    end
    addon:RefreshState()
end)

SLASH_SHAMANASSIST1 = "/sha"
SLASH_SHAMANASSIST2 = "/shamanassist"
SlashCmdList.SHAMANASSIST = function(message)
    local command = (message or ""):lower():match("^%s*(%S*)")
    if command == "test" then addon:TestAlert()
    elseif command == "stop" then addon:StopTest()
    elseif command == "status" then addon:PrintStatus()
    elseif command == "rescan" then addon:RequestScan()
    elseif command == "unlock" then ShamanAssistDB.locked=false; addon:ApplySettings(); addon:TestAlert()
    elseif command == "lock" then ShamanAssistDB.locked=true; addon:StopTest(); addon:ApplySettings()
    else addon:OpenStandaloneSettings() end
end
