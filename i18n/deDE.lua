
local addonName, addon = ...
local locale = GetLocale()

if locale == "deDE" then
    local L = addon.L
    L["ShowHKs"] = "Zeige Ehrenhafte Siege";
    L["ShowHKsDescription"] = "Shows the total number of honor kills within the data text."

    L["Show Currency Icons"] = "Zeige Symbole";
    L["Show Currency Labels"] = "Zeige Beschriftung";
    L["Show Currency Limits"] = "Show Currency Limits";
    L["Use Short Labels"] = "Benutze Abkürzungen";
    L["Scoreboard"] = "Anzeigetafel";
    L["Score: "] = "Ergebnis: ";
    L["Honor Kills"] = "Ehrenhafte Siege";
  addon.L = L
end
