local addonName, addon = ...
local L = addon.L
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local function print(...) _G.print("|cff259054Scoreboard:|r", ...) end

function addon:GetCurrencyListInfo(...)
  if type(C_CurrencyInfo.GetCurrencyListInfo) == "function" then
    return C_CurrencyInfo.GetCurrencyListInfo(...)
  end
  -- backport new table signature from BFA method
  local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, _, _, _ = GetCurrencyListInfo(...)
  return {
    name=name,
    isHeader=isHeader,
    isHeaderExpanded=isExpanded,
    isTypeUnused=isUnused,
    isShowInBackpack=isWatched,
    quantity=count,
    iconFileID = icon,
    maximum = maximum,
  };
end

function addon:GetCurrencyListSize()
  if type(C_CurrencyInfo.GetCurrencyListSize) == "function" then
    return C_CurrencyInfo.GetCurrencyListSize()
  end
  return GetCurrencyListSize()
end

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

    if type(ScoreboardSettings) ~= "table" then ScoreboardSettings = {currencies={}} end
    local sv = ScoreboardSettings
    if type(sv.currencies) ~= "table" then sv.currencies = {} end
    if type(sv.showHKs) ~= "boolean" then sv.showHKs = true end
    if type(sv.showIcons) ~= "boolean" then sv.showIcons = true end
    if type(sv.showLabels) ~= "boolean" then sv.showLabels = true end
    if type(sv.showLimits) ~= "boolean" then sv.showLimits = true end
    if type(sv.showHeaders) ~= "boolean" then sv.showHeaders = true end
    if type(sv.useShortLabels) ~= "boolean" then sv.useShortLabels = false end
    addon.db = sv

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
    OnClick = function(self, button)
      if button == "RightButton" then
        showConfig()
      else
        ToggleCharacter("TokenFrame");
      end
    end
  })

  -- Remove any non-word characters that cause issues saving in other locales
  local function getIconKey(icon) return gsub(icon, "[^%w]", "") end

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
    local size = addon:GetCurrencyListSize();

    local function renderItem(name, count, icon, mx)
      local t = ""
      if (addon.db.showIcons) then t = t..fmtIcon(icon) end
      t = t..fmtLabel(name)..highlight(count);
      if (addon.db.showLimits and mx and mx > 0) then t = t.."/"..mx end
      return t
    end

    for i=1, size do
      local c = addon:GetCurrencyListInfo(i)
      if (not c.isHeader) then
        if (addon:getCurrency(c.iconFileID) and not c.isTypeUnused) then
          text = text..renderItem(c.name, c.quantity, c.iconFileID, c.maximum)
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

  local function updateTooltip()
    local size = addon:GetCurrencyListSize()

    local function renderItem(name, count, icon, max)
      local t = ""
      t = t..fmtIcon(icon)..normal(name)..highlight(count)
      if (mx and mx > 0) then t = t.."/"..mx end
      return t
    end

    GameTooltip:AddLine(L["Scoreboard"].."\n")
    GameTooltip:AddLine(muted(L["usageDescription"]))

    for i=1, size do
      local c = addon:GetCurrencyListInfo(i)
      if c.isHeader then
        if c.isHeaderExpanded and addon.db.showHeaders and c.name ~= "Unused" then
          GameTooltip:AddLine(highlight(c.name).."\n")
        end
      else
        if not c.isUnused then
          -- @todo stylize the count when nearing limit?
          local ltext = fmtIcon(c.iconFileID)..c.name
          local rtext = highlight(c.quantity)
          if addon.db.showLimits and c.maximum and c.maximum > 0 then
            rtext = rtext.." / "..highlight(c.maximum)
          end
          GameTooltip:AddDoubleLine(ltext, rtext)
        end
      end
    end

    if (addon.db.showHKs) then
      GameTooltip:AddLine(highlight(L["PvP Stats"]).."\n")
      local hks, dks, rank = GetPVPLifetimeStats()
      -- @todo pull translations for kills?
      GameTooltip:AddDoubleLine(L["Honorable Kills"], highlight(hks))
      GameTooltip:AddDoubleLine(L["Dishonorable Kills"], highlight(dks))
      GameTooltip:AddDoubleLine(L["Honor Rank"], muted("unknown"))
      -- Honor rank ?

      -- GameTooltip:AddDoubleLine(fmtIcon([[Interface\ICONS\Achievement_Pvp_p_03]])..L["Highest Rank"], highlight(rank))
      -- local name, number = GetPVPRankInfo(rank);
      -- GameTooltip:AddDoubleLine(fmtIcon([[Interface\ICONS\Achievement_Pvp_p_03]])..L["Highest Rank"], highlight(number..": "..name))
    elseif (size == 0) then
      GameTooltip:AddLine(muted(L["No currencies can be displayed."]))
    end
  end

  function addon:setDB(key, value)
    addon.db[key] = value
    updateText()
  end

  function addon:setCurrency(icon, value)
    local ik = getIconKey(icon)
    addon.db.currencies[ik] = value
    updateText()
  end

  function addon:getCurrency(icon)
    local ik = getIconKey(icon)
    return addon.db.currencies[ik] == true
  end

  f:RegisterEvent("PLAYER_ENTERING_WORLD");
  f:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
  f:SetScript("OnEvent", function(self, event)
    if(event == "CURRENCY_DISPLAY_UPDATE" or event == "PLAYER_ENTERING_WORLD") then
      updateText()
    end
  end)

  function dataobj:OnTooltipShow()
    updateTooltip(self)
  end

  function dataobj:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
    GameTooltip:ClearLines()
    dataobj.OnTooltipShow()
    GameTooltip:Show()
  end

  function dataobj:OnLeave()
    GameTooltip:Hide()
  end
end
