
local addonName, addon = ...
local locale = GetLocale()

if locale == "esES" then
    local L = {}
    L["ShowHKs"] = "Показывать Почетные победы";
    L["ShowHKsDescription"] = "Shows the total number of honor kills within the data text."

    L["Show Currency Icons"] = "Показывать значки";
    L["Show Currency Labels"] = "Показывать названия";
    L["Show Currency Limits"] = "Показывать Limits";
    L["Use Short Labels"] = "Сокращения";
    L["Scoreboard"] = "Scoreboard";
    L["Score: "] = "Score: ";
    L["Honor Kills"] = "Почетные победы";
  addon.L = L
end
