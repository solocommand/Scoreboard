
local addonName, addon = ...
local locale = GetLocale()

if locale == "frFR" then
    local L = {}
    L["ShowHKs"] = "Afficher Victoires Honorables";
    L["ShowHKsDescription"] = "Shows the total number of honor kills within the data text."

    L["Show Currency Icons"] = "Afficher l'icône";
    L["Show Currency Labels"] = "Afficher les noms";
    L["Show Currency Limits"] = "Show Currency Limits";
    L["Use Short Labels"] = "Utiliser les noms courts";
    L["Scoreboard"] = "Tableau de bord";
    L["Score: "] = "Le score: ";
    L["Honor Kills"] = "Victoires Honorables";
  addon.L = L
end
