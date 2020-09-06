local addonName, addon = ...
local L = addon.L
local function print(...) _G.print("|cff259054Scoreboard:|r", ...) end

local GetCurrencyListInfo = function(...)
  if type(C_CurrencyInfo.GetCurrencyListInfo) == "function" then
    return C_CurrencyInfo.GetCurrencyListInfo(...)
  end
  return GetCurrencyListInfo(...)
end
local GetCurrencyListSize = function()
  if type(C_CurrencyInfo.GetCurrencyListSize) == "function" then
    return C_CurrencyInfo.GetCurrencyListSize()
  end
  return GetCurrencyListSize()
end

local frame = addon.frame
frame.name = addonName
frame:Hide()

frame:SetScript("OnShow", function(frame)
  local function newCheckbox(label, description, onClick)
    local check = CreateFrame("CheckButton", "ScoreboardCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
    check:SetScript("OnClick", function(self)
      local tick = self:GetChecked()
      onClick(self, tick and true or false)
      if tick then
        PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
      else
        PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
      end
    end)
    check.label = _G[check:GetName() .. "Text"]
    check.label:SetText(label)
    check.tooltipText = label
    check.tooltipRequirement = description
    return check
  end

  -- Settings

  local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText(L["settingsTitle"])

  local showHKs = newCheckbox(L.showHKs, L.showHKsDescription, function(_, value) addon:setDB("showHKs", value) end)
  showHKs:SetChecked(addon.db.showHKs)
  showHKs:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)

  local showIcons = newCheckbox(L.showIcons, L.showIconsDescription, function(_, value) addon:setDB("showIcons", value) end)
  showIcons:SetChecked(addon.db.showIcons)
  showIcons:SetPoint("TOPLEFT", showHKs, "BOTTOMLEFT", 0, -8)

  local showLabels = newCheckbox(L.showLabels, L.showLabelsDescription, function(_, value) addon:setDB("showLabels", value) end)
  showLabels:SetChecked(addon.db.showLabels)
  showLabels:SetPoint("TOPLEFT", showIcons, "BOTTOMLEFT", 0, -8)

  local showLimits = newCheckbox(L.showLimits, L.showLimitsDescription, function(_, value) addon:setDB("showLimits", value) end)
  showLimits:SetChecked(addon.db.showLimits)
  showLimits:SetPoint("TOPLEFT", showLabels, "BOTTOMLEFT", 0, -8)

  local useShortLabels = newCheckbox(L.useShortLabels, L.useShortLabelsDescription, function(_, value) addon:setDB("useShortLabels", value) end)
  useShortLabels:SetChecked(addon.db.useShortLabels)
  useShortLabels:SetPoint("TOPLEFT", showLimits, "BOTTOMLEFT", 0, -8)

  local showHeaders = newCheckbox(L.showHeaders, L.showHeadersDescription, function(_, value) addon:setDB("showHeaders", value) end)
  showHeaders:SetChecked(addon.db.showHeaders)
  showHeaders:SetPoint("TOPLEFT", useShortLabels, "BOTTOMLEFT", 0, -8)

  local showPlaceholder = newCheckbox(L.showPlaceholder, L.showPlaceholderDescription, function(_, value) addon:setDB("showPlaceholder", value) end)
  showPlaceholder:SetChecked(addon.db.showPlaceholder)
  showPlaceholder:SetPoint("TOPLEFT", showHeaders, "BOTTOMLEFT", 0, -8)

  -- Currencies

  local currencies = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  currencies:SetPoint("TOPLEFT", 320, -16)
  currencies:SetText(L["currenciesTitle"])

  local currenciesDescription = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  currenciesDescription:SetPoint("TOPLEFT", currencies, "BOTTOMLEFT", 0, -8)
  currenciesDescription:SetText(DISABLED_FONT_COLOR_CODE..L["currenciesDescription"]..FONT_COLOR_CODE_CLOSE)

  local size = GetCurrencyListSize()
  local lastFrame = currenciesDescription

  for i=1, size do
    local name, isHeader, isExpanded, isUnused, _, count, icon, maximum, _, _, _ = GetCurrencyListInfo(i)
    if isHeader then
      if isExpanded and name ~= "Unused" then
        local f = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        f:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -8)
        f:SetText(NORMAL_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE)
        lastFrame = f
      end
    else
      if not isUnused then
        print("create checkbox for "..name)
        local f = newCheckbox(name, nil, function(_, value) addon:setCurrency(icon, value) end)
        f:SetChecked(addon:getCurrency(icon))
        f:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -8)
        lastFrame = f
      end
    end
  end

  --

  frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)
