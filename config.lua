
local addonName, addon = ...
local L = addon.L

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

  local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText(addonName)

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

  frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)
