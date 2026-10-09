local _,addon=...
addon.heroNames={[54]="Totemic",[55]="Stormbringer",[56]="Farseer"}

function addon:RegisterHeroAlerts()
    local function Add(spec,suffix,name,aura,hero,spells,totem)
        local key=(spec==262 and "ele" or spec==263 and "enh" or "resto")..suffix
        self.info[key]={name=name,aura=aura,icon=totem or aura,spells=spells or {aura},
            spec=spec,hero=hero,text=name:upper(),kind="activeBuff",totemSpell=totem,heroAdded=true}
        self.order[#self.order+1]=key
        self.specOrders[spec][#self.specOrders[spec]+1]=key
    end
    for _,spec in ipairs({262,263}) do
        Add(spec,"UnlimitedPower","Unlimited Power",454394,55)
        Add(spec,"StormSwell","Storm Swell",455089,55)
        Add(spec,"SurgingCurrents","Surging Currents",454376,55)
        Add(spec,"Electroshock","Electroshock",454025,55)
        Add(spec,"LightningConduit","Lightning Conduit",468226,55)
    end
    Add(263,"ArcDischarge","Arc Discharge",470532,55)
    Add(263,"NatureSpirit","Nature Spirit",224127,55)
    -- Elemental Arc Discharge grants the existing Stormkeeper buff.
    Add(262,"Stormkeeper","Stormkeeper",191634,nil)
    for _,spec in ipairs({263,264}) do
        Add(spec,"SurgingTotem","Surging Totem",1221347,54,{444995,455630,1221347},444995)
        Add(spec,"WhirlingAir","Whirling Air",453409,54)
        Add(spec,"WhirlingEarth","Whirling Earth",453406,54)
        Add(spec,"AmplificationCore","Amplification Core",456369,54)
        Add(spec,"WindBarrier","Wind Barrier",457387,54)
    end
    Add(263,"WhirlingFire","Whirling Fire",453405,54)
    Add(264,"WhirlingWater","Whirling Water",453407,54)
    Add(263,"TotemicRebound","Totemic Rebound",458269,54)
    Add(263,"LivelyTotems","Lively Totems",461242,54)
    Add(263,"PrimalCatalyst","Primal Catalyst",1260880,54)
    for _,spec in ipairs({262,264}) do
        Add(spec,"Ancestors","Call of the Ancestors",447244,56,{443450,447244})
        Add(spec,"AncestralSwiftness","Ancestral Swiftness",443454,56,{443454,448861})
    end
    Add(264,"LavaSurge","Lava Surge",77762,nil,{51505})
    Add(264,"MysticKnowledge","Mystic Knowledge",1270453,56)
    self.info.restoLavaSurge.kind="proc"
    for _,key in ipairs({"tempest","tempestBuff","eleTempest"}) do self.info[key].hero=55 end
end

function addon:UpdateHeroSpec()
    local hero=self:Public(self:SafeCall(C_ClassTalents and C_ClassTalents.GetActiveHeroTalentSpec),"number")
    self.heroID=self.heroNames[hero] and hero or nil
end
function addon:IsHeroEligible(info)
    -- When the hero API is unavailable, actual aura evidence can still be
    -- used. Never infer a proc, stack count or summon from talent selection.
    return not info.hero or not self.heroID or info.hero==self.heroID
end

function addon:ReadHeroTotem(info,state)
    if not info.totemSpell or type(GetTotemInfo)~="function" then return false end
    local slots=self:Public(self:SafeCall(GetNumTotemSlots),"number") or 4
    local expectedName=self:Public(self:SafeCall(C_Spell and C_Spell.GetSpellName,info.totemSpell),"string")
    for slot=1,math.min(slots,16) do
        local ok,present,name,start,duration,_,_,spellID=pcall(GetTotemInfo,slot)
        present=self:Public(present,"boolean");name=self:Public(name,"string");spellID=self:Public(spellID,"number")
        if ok and present and (spellID==info.totemSpell or spellID==455630 or (expectedName and name==expectedName)) then
            state.active=true;state.status="Active totem"
            state.durationObject=self:SafeCall(GetTotemDuration,slot)
            start=self:Public(start,"number");duration=self:Public(duration,"number")
            if start and duration then
                state.expiration=start+duration;state.totalDuration=duration
                if state.expiration<=GetTime() then state.active=false end
            end
            return true
        end
    end
    return false
end
