local addonName, addon = ...
local L = addon.L
local ldbi = LibStub('LibDBIcon-1.0', true)

local function build()
  local t = {
    name = "Scoreboard",
    handler = Scoreboard,
    type = 'group',
    args = {
      showMinimapIcon = {
        type = 'toggle',
        name = L['Show minimap button'],
        desc = L['Show the Scoreboard minimap button'],
        order = 0,
        get = function(info) return not addon.db.minimap.hide end,
        set = function(info, value)
          local config = addon.db.minimap
          config.hide = not value
          addon:setDB("minimap", config)
          ldbi:Refresh(addonName)
        end,
      },
      showHKs = {
        type = 'toggle',
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
        name = L.showHKs,
        desc = L.showHKsDescription,
      },
      showIcons = {
        type = 'toggle',
        order = 2,
        name = L.showIcons,
        desc = L.showIconsDescription,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
      },
      showLabels = {
        type = 'toggle',
        order = 3,
        name = L.showLabels,
        desc = L.showLabelsDescription,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
      },
      showLimits = {
        type = 'toggle',
        order = 4,
        name = L.showLimits,
        desc = L.showLimitsDescription,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
      },
      useShortLabels = {
        type = 'toggle',
        order = 5,
        name = L.useShortLabels,
        desc = L.useShortLabelsDescription,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
      },
      showHeaders = {
        type = 'toggle',
        order = 7,
        name = L.showHeaders,
        desc = L.showHeadersDescription,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
      },
      disableUsageText = {
        type = 'toggle',
        order = 8,
        name = L.disableUsageText,
        desc = L.disableUsageTextDescription,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value) return addon:setDB(info[#info], value) end,
      },
      currencies = {
        type = "header",
        name = L["currenciesTitle"],
        order = 10,
      },
    }
  }

  -- add currencies
  for i=1, C_CurrencyInfo.GetCurrencyListSize() do
    local c = C_CurrencyInfo.GetCurrencyListInfo(i)
    local li = C_CurrencyInfo.GetCurrencyListLink(i)
    if c.isHeader then
      if c.isHeaderExpanded and c.name ~= "Unused" then
        t.args[c.name] = {
          type = 'header',
          order = 20 + i,
          name = c.name,
        }
      end
    else
      if not c.isTypeUnused then
        t.args[c.name] = {
          type = 'toggle',
          order = 20 + i,
          name = c.name,
          get = function() return addon:getCurrency(li) end,
          set = function(i, v) return addon:setCurrency(li, v) end,
        }
      end
    end
  end

  -- return our new table
  return t
end

LibStub("AceConfig-3.0"):RegisterOptionsTable("Scoreboard", build, nil)
addon.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "Scoreboard")
LibStub("AceConsole-3.0"):RegisterChatCommand("scoreboard", function() InterfaceOptionsFrame_OpenToCategory(addon.optionsFrame) end)
