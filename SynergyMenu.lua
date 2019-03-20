synergy = synergy or {}
local syn = synergy

local LAM = LibStub("LibAddonMenu-2.0")

function syn.buildMenu()
	local panelData = {
		type = "panel",
		name = syn.name,
		displayName = "|cd7f442S|rynergy",
		author = "Wheel5",
		version = ""..syn.version,
		registerForRefresh = true,
	}
	
	local options = {
		{
			type = "header",
			name = "Settings",
		},
		{
			type = "checkbox",
			name = "Trials Only",
			tooltip = "When enabled, extreme synergy blocking will only take effect in a trial zone (RECOMMENDED)",
			default = true,
			getFunc = function() return syn.savedVariables.trialsOnly end,
			setFunc = function(value) syn.savedVariables.trialsOnly = value end,
		},
		{
			type = "description",
			text = "Extreme syngery blocking will disable the use of ALL SYNERGIES for dps when there is no Alkosh applied to the boss. If you are in a raid setting where alkosh is not likely to be consistent, it is not recommended to enable this setting.",
		},
		{
			type = "checkbox",
			name = "Extreme Synergy Blocking",
			tooltip = "Disables the use of ALL SYNERGIES for dps players when alkosh is down on a boss",
			default = false,
			getFunc = function() return syn.savedVariables.ExtremeBlocking end,
			setFunc = function(value) syn.savedVariables.ExtremeBlocking = value end,
		},
		{
			type = "checkbox",
			name = "Disable Cloudrest Portal",
			tooltip = "Disables the use of the portal synergy in Cloudrest when enabled",
			default = false,
			getFunc = function() return syn.savedVariables.portalDisable end,
			setFunc = function(value) syn.savedVariables.portalDisable = value end,
		},
		{
			type = "description",
			text = "Maelstrom Arena and Blackrose Prison share the same Defense and Healing sigil name, so if you have one of the following settings enabled the sigil will be disabled in BOTH trials.",
		},
		{
			type = "checkbox",
			name = "Disable Blackrose Prison Sigils",
			tooltip = "When enabled, the sigils in Blackrose Prison can not be used",
			default = false,
			getFunc = function() return syn.savedVariables.brpSynDisable end,
			setFunc = function(value) syn.savedVariables.brpSynDisable = value end,
		},
		{
			type = "checkbox",
			name = "Disable Maelstrom Arena Sigils",
			tooltip = "When enabled, the sigils in Maelstrom Arena can not be used",
			default = false,
			getFunc = function() return syn.savedVariables.maSynDisable end,
			setFunc = function(value) syn.savedVariables.maSynDisable = value end,
		},
	}
	
	LAM:RegisterAddonPanel(syn.name.."Options", panelData)
	LAM:RegisterOptionControls(syn.name.."Options", options)
end
