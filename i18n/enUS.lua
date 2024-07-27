
local addonName, addon = ...

local L = {}

-- Configuration options
L["showHKs"] = "Show Honor Kills";
L["showHKsDescription"] = "Shows the total number of honor kills within the data text."

L["showInAddonCompartment"] = "Show in compartment"
L["showInAddonCompartmentDescription"] = "Toggles the display of Scoreboard within the addon compartment."

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

L["disableUsageText"] = "Disable usage text"
L["disableUsageTextDescription"] = "If checked, the usage instructions will not be shown on the tooltip."

L["settingsTitle"] = "Settings";
L["settingsDescription"] = "Settings description here";

L["currenciesTitle"] = "Currencies"
L["currenciesDescription"] = "Currencies description here";
-- L["resetSettingsDescription"] = "Remove all customizations and set the options back to defaults."

-- Messages
L["No currencies can be displayed."] = "No currencies can be displayed.";
L["usageDescription"] = "Left-click to view currencies. Right-click to configure."
-- L["Settings have been reset to defaults."] = "Settings have been reset to defaults."

-- Labels
L["Scoreboard"] = "Scoreboard";
L["Honorable Kills"] = "Honorable Kills";
L["Dishonorable Kills"] = "Dishonorable Kills";
L["Honor Level"] = "Honor Level";
L["PvP Stats"] = "PvP Stats";

L['Show minimap button'] = 'Show minimap button'
L['Show the Scoreboard minimap button'] = 'Show the Scoreboard minimap button'

addon.L = L
