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

local scrollFrame = CreateFrame("ScrollFrame", "ScoreboardConfigScrollFrame", frame, "UIPanelScrollFrameTemplate");
local scrollChild = CreateFrame("Frame")

local scrollbarName = scrollFrame:GetName()
local scrollbar = _G[scrollbarName.."ScrollBar"];
local scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"];
local scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"];

scrollupbutton:ClearAllPoints();
scrollupbutton:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -4, -5);
scrolldownbutton:ClearAllPoints();
scrolldownbutton:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -4, 4);
scrollbar:ClearAllPoints();
scrollbar:SetPoint("TOP", scrollupbutton, "BOTTOM", 0, -2);
scrollbar:SetPoint("BOTTOM", scrolldownbutton, "TOP", 0, 2);
scrollFrame:SetScrollChild(scrollChild);
scrollFrame:SetAllPoints(frame);
scrollChild:SetSize(scrollFrame:GetWidth(), scrollFrame:GetHeight() * 2);

frame:SetScript("OnShow", function(parent)
  local function newCheckbox(label, description, onClick)
    local check = CreateFrame("CheckButton", "ScoreboardCheck" .. label, scrollChild, "InterfaceOptionsCheckButtonTemplate")
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

  local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
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

  -- Currencies

  local currencies = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  currencies:SetPoint("TOPLEFT", 320, -16)
  currencies:SetText(L["currenciesTitle"])

  local currenciesDescription = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  currenciesDescription:SetPoint("TOPLEFT", currencies, "BOTTOMLEFT", 0, -8)
  currenciesDescription:SetText(DISABLED_FONT_COLOR_CODE..L["currenciesDescription"]..FONT_COLOR_CODE_CLOSE)

  local size = addon:GetCurrencyListSize()
  local lastFrame = currenciesDescription

  for i=1, size do
    local c = addon:GetCurrencyListInfo(i)
    if c.isHeader then
      if c.isHeaderExpanded and c.name ~= "Unused" then
        local f = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        f:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -8)
        f:SetText(NORMAL_FONT_COLOR_CODE..c.name..FONT_COLOR_CODE_CLOSE)
        lastFrame = f
      end
    else
      if not c.isTypeUnused then
        local f = newCheckbox(c.name, nil, function(_, value) addon:setCurrency(c.iconFileID, value) end)
        f:SetChecked(addon:getCurrency(c.iconFileID))
        f:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -8)
        lastFrame = f
      end
    end
  end

  --

  frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)
