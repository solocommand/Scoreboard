
local addonName, addon = ...
local locale = GetLocale()

if locale == "esES" then
    local L = {}
    L["ShowHKs"] = "Show Honor Kills";
    L["ShowHKsDescription"] = "Shows the total number of honor kills within the data text."

    L["Show Currency Icons"] = "Mostrar icono de puntos";
    L["Show Currency Labels"] = "Mostrar etiqueta de puntos";
    L["Show Currency Limits"] = "Show Currency Limits";
    L["Use Short Labels"] = "Mostrar pequeño etiqueta";
    L["Scoreboard"] = "Scoreboard";
    L["Score: "] = "Score: ";
    L["Honor Kills"] = "Honor Kills";
  addon.L = L
end
