
local addonName, addon = ...

local L = {}

-- Configuration options
L["showHKs"] = "Show Honor Kills";
L["showHKsDescription"] = "Shows the total number of honor kills within the data text."

L["showIcons"] = "Show currency icons";
L["showIconsDescription"] = "Includes the relevant currency icon next to the amount owned within the data text."

L["showLabels"] = "Show currency labels";
L["showLabelsDescription"] = "Includes the relevant currency label next to the amount owned within the data text."

L["showLimits"] = "Show currency limits";
L["showLimitsDescription"] = "If the currency has a limit or cap, include it after the amount owned within the data text."

L["showHeaders"] = "Show currency headers";
L["showHeadersDescription"] = "Show the currency groupings within the tooltip."

L["useShortLabels"] = "Use short labels";
L["useShortLabelsDescription"] = "Shorten the data text by changing the label to use an abbreviated form of the currency name."

-- L["resetSettings"] = "Reset settings";
-- L["resetSettingsDescription"] = "Remove all customizations and set the options back to defaults."

-- Messages
-- L["Settings have been reset to defaults."] = "Settings have been reset to defaults."

-- Labels
L["Scoreboard"] = "Scoreboard";
L["Score: "] = "Score: ";
L["Honor Kills"] = "Honor Kills";
addon.L = L
