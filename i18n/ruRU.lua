
local addonName, addon = ...
local locale = GetLocale()

if locale == "ruRU" then
    local L = {}
-- Configuration options
	L["showHKs"] = "Почётные победы";
	L["showHKsDescription"] = "Показывать общее количество почётных побед.";

	L["showIcons"] = "Значки валют";
	L["showIconsDescription"] = "Показывать значки валют рядом с количеством.";

	L["showLabels"] = "Названия валют";
	L["showLabelsDescription"] = "Показывать названия валют рядом с количеством.";

	L["showLimits"] = "Лимиты валют";
	L["showLimitsDescription"] = "Если у валюты есть ограничение или лимит, показать его после имеющегося количества.\nНапример, (2/6).";

	L["showHeaders"] = "Группировать валюты";
	L["showHeadersDescription"] = "Группировать валюты в всплывающей подсказке.";

	L["useShortLabels"] = "Сокращения";
	L["useShortLabelsDescription"] = "Сокращать названия валют.";

	L["showPlaceholder"] = "Show placeholder text";
	L["showPlaceholderDescription"] = "When no currencies are visible, should placeholder text be shown (to allow you to quickly access settings).\nIf disabled, use the /scoreboard command to bring up this settings window.";

	L["settingsTitle"] = "Settings";
	L["settingsDescription"] = "Settings description here";

	L["currenciesTitle"] = "Currencies";
	L["currenciesDescription"] = "Currencies description here";
	-- L["resetSettingsDescription"] = "Remove all customizations and set the options back to defaults."

-- Messages
	L["No currencies can be displayed."] = "No currencies can be displayed.";
	L["usageDescription"] = "ЛКМ для открытия окна валют. ПКМ для открытия настроек.";
	-- L["Settings have been reset to defaults."] = "Settings have been reset to defaults."

-- Labels
	L["Scoreboard"] = "Scoreboard";
	L["Honorable Kills"] = "Honorable Kills";
	L["Dishonorable Kills"] = "Dishonorable Kills";
	L["Honor Level"] = "Уровень Чести";
	L["PvP Stats"] = "PvP Stats";

	L['Show minimap button'] = 'Кнопка у миникарты';
	L['Show the Scoreboard minimap button'] = 'Отображать кнопку Scoreboard у миникарты.';

  addon.L = L
end
