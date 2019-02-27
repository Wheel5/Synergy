synergy = synergy or {}
local syn = synergy

local LAM = LibStub("LibAddonMenu-2.0")

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
}

LAM:RegisterAddonPanel(syn.name.."Options", panelData)
LAM:RegisterOptionControls(syn.name.."Options", options)
