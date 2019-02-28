synergy = synergy or {}
local syn = synergy
local EM = GetEventManager()

syn.name = "Synergy"
syn.version = "1.3"

local defaults = {
	["ExtremeBlocking"] = false,
}

syn.CustomAbilityName = {
	[75753] = GetAbilityName(75753),	-- Line-Breaker
}

local function GetFormattedAbilityName(id)
	local name = syn.CustomAbilityName[id] or zo_strformat(SI_ABILITY_NAME, GetAbilityName(id))
	return name
end

syn.alkosh = true

function syn.alkoshActive()
	if DoesUnitExist("boss1") and not DoesUnitExist("boss2") and not syn.excludeBoss[GetUnitName("boss1")] then
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
			if n and syn.dpsSynergyBL[n] then return end
			if n and not syn.alkosh and not syn.excludeSyn[n] then return end
		elseif h then
			if n and syn.healSynergyBL[n] then return end
		elseif t then
			if n and syn.tankSynergyBL[n] then return end
		end
		onSynAbChng(self)
	end

end

function syn.combat(e, inCombat)
	if inCombat and syn.savedVariables.ExtremeBlocking then
		EM:RegisterForUpdate(syn.name.."alkoshCheck", 50, syn.alkoshActive)
	else
		EM:UnregisterForUpdate(syn.name.."alkoshCheck")
	end
end

local function buildTables()
	syn.dpsSynergyBL = {
		[GetString(SI_SYNERGY_ABILITY_CONDUIT)] = true,
		[GetString(SI_SYNERGY_ABILITY_HARVEST)] = true,
	}
	
	syn.tankSynergyBL = {
		[GetString(SI_SYNERGY_ABILITY_CHARGED_LIGHTNING)] = true,
		[GetString(SI_SYNERGY_ABILITY_IMPALE)] = true,
		[GetString(SI_SYNERGY_ABILITY_GRAVITY_CRUSH)] = true,
	}
	
	syn.healSynergyBL = {
		[GetString(SI_SYNERGY_ABILITY_CHARGED_LIGHTNING)] = true,
		[GetString(SI_SYNERGY_ABILITY_IMPALE)] = true,
		[GetString(SI_SYNERGY_ABILITY_GRAVITY_CRUSH)] = true,
		[GetString(SI_SYNERGY_ABILITY_CONDUIT)] = true,
	}
	
	syn.excludeBoss = {
		[GetString(SI_SYNERGY_BOSS_THE_MAGE)] = true,
	}

	syn.excludeSyn = {
		[GetString(SI_SYNERGY_ABILITY_DROP_HOARFROST)] = true,
		[GetString(SI_SYNERGY_ABILITY_CELESTIAL_PURGE)] = true,
		[GetString(SI_SYNERGY_ABILITY_POWER_SWITCH)] = true,
		[GetString(SI_SYNERGY_ABILITY_GATEWAY)] = true,
		[GetString(SI_SYNERGY_ABILITY_REMOVE_BOLT)] = true,
		[GetString(SI_SYNERGY_ABILITY_DESTRUCTIVE_OUTBREAK)] = true, -- TEMPORARY
		[GetString(SI_SYNERGY_ABILITY_MALEVOLENT_CORE)] = true,
		[GetString(SI_SYNERGY_ABILITY_WELKYNARS_LIGHT)] = true,
	}
end

function syn.init(event, addon)
	if addon ~= syn.name then return end
	EM:UnregisterForEvent(syn.name.."Load", EVENT_ADD_ON_LOADED)
	syn.savedVariables = ZO_SavedVars:New("SynergySavedVars", 1, nil, defaults, GetWorldName())

	buildTables()
	syn.buildMenu()
	syn.SynergyOverride()
	EM:RegisterForEvent(syn.name.."Combat", EVENT_PLAYER_COMBAT_STATE, syn.combat)
end

EM:RegisterForEvent(syn.name.."Load", EVENT_ADD_ON_LOADED, syn.init)
