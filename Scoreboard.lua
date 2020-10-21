local addonName, addon = ...
local L = addon.L
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local ldbi = LibStub:GetLibrary('LibDBIcon-1.0')

local function showConfig()
  InterfaceOptionsFrame_OpenToCategory(addonName)
  InterfaceOptionsFrame_OpenToCategory(addonName)
end

local function normal(text)
  if not text then return "" end
  return NORMAL_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
end

local function highlight(text)
  if not text then return "" end
  return HIGHLIGHT_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
end

local function muted(text)
  if not text then return "" end
  return DISABLED_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
end


-- Init & config panel
do
	local eventFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
  eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon ~= addonName then return end
    self:UnregisterEvent("ADDON_LOADED")

    if type(ScoreboardSettings) ~= "table" then ScoreboardSettings = {currencies={},minimap={hide=false}} end
    local sv = ScoreboardSettings
    if type(sv.currencies) ~= "table" then sv.currencies = {} end
    if type(sv.minimap) ~= "table" then sv.minimap = {hide=false} end
    if type(sv.showHKs) ~= "boolean" then sv.showHKs = true end
    if type(sv.showIcons) ~= "boolean" then sv.showIcons = true end
    if type(sv.showLabels) ~= "boolean" then sv.showLabels = true end
    if type(sv.showLimits) ~= "boolean" then sv.showLimits = true end
    if type(sv.showHeaders) ~= "boolean" then sv.showHeaders = true end
    if type(sv.useShortLabels) ~= "boolean" then sv.useShortLabels = false end
    if type(sv.disableUsageText) ~= "boolean" then sv.disableUsageText = false end
    addon.db = sv

    ldbi:Register(addonName, addon.dataobj, addon.db.minimap)

		self:SetScript("OnEvent", nil)
	end)
	eventFrame:RegisterEvent("ADDON_LOADED")
  addon.frame = eventFrame
end

-- data text
do
  local f = CreateFrame("frame")
  local text = "..loading.."
  local tooltip = ""
  local dataobj = ldb:NewDataObject("Scoreboard", {
    type = "data source",
    icon = "Interface\\ICONS\\achievement_pvp_a_14",
    text = text,
    OnEnter = function(frame)
      GameTooltip:SetOwner(frame, "ANCHOR_NONE")
      GameTooltip:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
      GameTooltip:ClearLines()
      addon:updateTooltip(frame)
      GameTooltip:Show()
    end,
    OnLeave = function()
      GameTooltip:Hide()
    end,
    OnClick = function(self, button)
      if button == "RightButton" then
        showConfig()
      else
        ToggleCharacter("TokenFrame");
      end
    end,
  })

  addon.dataobj = dataobj

  -- Remove any non-word characters that cause issues saving in other locales
  local function getCurrencyKeyID(ilink) return C_CurrencyInfo.GetCurrencyIDFromLink(ilink) end

  local function fmtIcon(icon)
    local text
    if not icon then icon = [[Interface\Icons\Temp]] end
    text = "  |T"..icon..":16:16:0:0:64:64:4:60:4:60|t ";
    return text;
  end

  local function fmtLabel(text)
    if not text then return "" end
    if not addon.db.showLabels then return "" end
    text = normal(text);
    if addon.db.useShortLabels then
      return normal(gsub(text, "[^%u]", ""))..": ";
    end
    return normal(text)..": ";
  end

  local function updateText()
    local text = "";
    local size = C_CurrencyInfo.GetCurrencyListSize();

    local function renderItem(name, count, icon, mx)
      local t = ""
      if (addon.db.showIcons) then t = t..fmtIcon(icon) end
      t = t..fmtLabel(name)..highlight(count);
      if (addon.db.showLimits and mx and mx > 0) then t = t.."/"..mx end
      return t
    end

    for i=1, size do
      local c = C_CurrencyInfo.GetCurrencyListInfo(i)
      local li = C_CurrencyInfo.GetCurrencyListLink(i)
      if (not c.isHeader) then
        if (addon:getCurrency(li) and not c.isTypeUnused) then
          text = text..renderItem(c.name, c.quantity, c.iconFileID, c.maxQuantity)
          if (i ~= size) then text = text.." " end
        end
      end
    end

    if (addon.db.showHKs) then
      local faction, _ = UnitFactionGroup("player")
      local count, _ = GetPVPLifetimeStats()
      local icon = [[Interface\ICONS\achievement_pvp_p_01]]
      if (faction == "Alliance") then
        icon = [[Interface\ICONS\achievement_pvp_a_01]]
      elseif (faction == "Horde") then
        icon = [[Interface\ICONS\achievement_pvp_h_01]]
      end
      text = text..renderItem(L["Honor Kills"], count, icon, 0)
    end

    dataobj.text = text;
  end

  function addon:updateTooltip()
    local size = C_CurrencyInfo.GetCurrencyListSize()

    local function renderItem(name, count, icon, max)
      local t = ""
      t = t..fmtIcon(icon)..normal(name)..highlight(count)
      if (mx and mx > 0) then t = t.."/"..mx end
      return t
    end

    GameTooltip:AddLine(L["Scoreboard"].."\n")
    if not addon.db.disableUsageText then
      GameTooltip:AddLine(muted(L["usageDescription"]).."\n")
    end

    for i=1, size do
      local c = C_CurrencyInfo.GetCurrencyListInfo(i)
      if c.isHeader then
        if c.isHeaderExpanded and addon.db.showHeaders and c.name ~= "Unused" then
          GameTooltip:AddLine(highlight(c.name).."\n")
        end
      else
        if not c.isUnused then
          -- @todo stylize the count when nearing limit?
          local ltext = fmtIcon(c.iconFileID)..c.name
          local rtext = highlight(c.quantity)
          if addon.db.showLimits and c.maxQuantity and c.maxQuantity > 0 then
            rtext = rtext.." / "..highlight(c.maxQuantity)
          end
          GameTooltip:AddDoubleLine(ltext, rtext)
        end
      end
    end

    if (addon.db.showHKs) then
      GameTooltip:AddLine(highlight(L["PvP Stats"]).."\n")
      local hks, dks = GetPVPLifetimeStats()
      local pct = string.format(" (%.f%%)", math.max(0, UnitHonor("player")) / math.max(1, UnitHonorMax("player")) * 100)
      GameTooltip:AddDoubleLine(L["Honorable Kills"], highlight(hks))
      GameTooltip:AddDoubleLine(L["Dishonorable Kills"], highlight(dks))
      GameTooltip:AddDoubleLine(L["Honor Level"], highlight(UnitHonorLevel("player"))..muted(pct))
    elseif (size == 0) then
      GameTooltip:AddLine(muted(L["No currencies can be displayed."]))
    end
  end

  function addon:setDB(key, value)
    addon.db[key] = value
    updateText()
  end

  function addon:setCurrency(ilink, value)
    local nk = getCurrencyKeyID(ilink)
    addon.db.currencies[nk] = value
    updateText()
  end

  function addon:getCurrency(ilink)
    local nk = getCurrencyKeyID(ilink)
    return addon.db.currencies[nk] == true
  end

  f:RegisterEvent("PLAYER_ENTERING_WORLD");
  f:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
  f:SetScript("OnEvent", function(self, event)
    if(event == "CURRENCY_DISPLAY_UPDATE" or event == "PLAYER_ENTERING_WORLD") then
      updateText()
    end
  end)
end
