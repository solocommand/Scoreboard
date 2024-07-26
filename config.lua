local addonName, addon = ...
local L = addon.L
local ldbi = LibStub('LibDBIcon-1.0', true)

local function buildCheckbox(key, order)
  return {
    type = 'toggle',
    name = L[key],
    order = order or 0,
    desc = L[key.."Description"],
    get = function(info) return addon.db[info[#info]] end,
    set = function(info, value) return addon:setDB(info[#info], value) end,
  }
end

local function build()
  local currencies = {}
  local t = {
    name = "Scoreboard",
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
      showInAddonCompartment = {
        type = 'toggle',
        name = L.showInAddonCompartment,
        desc = L.showInAddonCompartmentDescription,
        order = 1,
        get = function(info) return addon.db[info[#info]] end,
        set = function(info, value)
          addon:setDB(info[#info], value)
          if value then
            ldbi:AddButtonToCompartment(addonName)
          else
            ldbi:RemoveButtonFromCompartment(addonName)
          end
        end
      },
      disableUsageText = buildCheckbox("disableUsageText", 2),
      dataText = {
        type = "group",
        name = "Data Text",
        order = 5,
        args = {
          showHKs = buildCheckbox("showHKs", 6),
          showIcons = buildCheckbox("showIcons", 7),
          showLabels = buildCheckbox("showLabels", 8),
          showLimits = buildCheckbox("showLimits", 9),
          useShortLabels = buildCheckbox("useShortLabels", 10),
        },
      },

      tooltip = {
        type = "group",
        name = "Tooltip",
        order = 15,
        args = {
          showHeaders = buildCheckbox("showHeaders", 16),
        }
      },
      currencies = {
        type = "group",
        name = L["currenciesTitle"],
        order = 20,
        args = currencies,
      },
    }
  }

  -- add currencies
  for i=1, C_CurrencyInfo.GetCurrencyListSize() do
    local c = C_CurrencyInfo.GetCurrencyListInfo(i)
    local li = C_CurrencyInfo.GetCurrencyListLink(i)
    if c.isHeader then
      if c.isHeaderExpanded and c.name ~= "Unused" then
        currencies[c.name] = {
          type = 'header',
          order = 30 + i,
          name = c.name,
        }
      end
    else
      if not c.isTypeUnused then
        currencies[c.name] = {
          type = 'toggle',
          order = 30 + i,
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
LibStub("AceConsole-3.0"):RegisterChatCommand("scoreboard", function() Settings.OpenToCategory(addonName) end)
