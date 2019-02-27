synergy = synergy or {}
local syn = synergy
local EM = GetEventManager()

syn.name = "Synergy"
syn.version = "1.0"

local defaults = {
	["ExtremeBlocking"] = false,
}

local dpsSynergyBL = {
	["Conduit"] = true,
	["Harvest"] = true,
}

local tankSynergyBL = {
	["Charged Lightning"] = true,
	["Impale"] = true,
	["Gravity Crush"] = true,
}

local healSynergyBL = {
	["Charged Lightning"] = true,
	["Impale"] = true,
	["Gravity Crush"] = true,
	["Conduit"] = true,
}

local excludeBoss = {
	["The Mage"] = true,
}

syn.CustomAbilityName = {
	[75753] = GetAbilityName(75753),	-- Line-Breaker
}

local function GetFormattedAbilityName(id)
	local name = syn.CustomAbilityName[id] or zo_strformat(SI_ABILITY_NAME, GetAbilityName(id))
	return name
end

syn.alkosh = true

local function alkoshActive()
	if DoesUnitExist("boss1") and not DoesUnitExist("boss2") and not excludeBoss[GetUnitName("boss1")] then
		local numBuffs = GetNumBuffs("boss1")
		for i = 1, numBuffs do
			local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("boss1", i)
			if buffName == GetFormattedAbilityName(75753) then
				syn.alkosh = true
				return
			end
		end
		syn.alkosh = false
	else
		syn.alkosh = true
	end
end

function syn.SynergyOverride()

	local onSynAbChng = SYNERGY.OnSynergyAbilityChanged
	
	function SYNERGY:OnSynergyAbilityChanged()
		local n, _ = GetSynergyInfo()
		local d, h, t = GetGroupMemberRoles('player')
		if d then
			if n and dpsSynergyBL[n] then return end
			if n and not syn.alkosh then return end
		elseif h then
			if n and healSynergyBL[n] then return end
		elseif t then
			if n and tankSynergyBL[n] then return end
		end
		onSynAbChng(self)
	end

end

function syn.combat(e, inCombat)
	if inCombat and syn.savedVariables.ExtremeBlocking then
		EM:RegisterForUpdate(syn.name.."alkoshCheck", 50, alkoshActive)
	else
		EM:UnregisterForUpdate(syn.name.."alkoshCheck")
	end
end

function syn.init(event, addon)
	if addon ~= syn.name then return end
	EM:UnregisterForEvent(syn.name.."Load", EVENT_ADD_ON_LOADED)
	syn.savedVariables = ZO_SavedVars:New("SynergySavedVars", 1, nil, defaults, GetWorldName())
	EM:RegisterForEvent(syn.name.."Combat", EVENT_PLAYER_COMBAT_STATE, syn.combat)

	syn.SynergyOverride()
end

EM:RegisterForEvent(syn.name.."Load", EVENT_ADD_ON_LOADED, syn.init)
