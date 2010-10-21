

----------------------------------------------------------------------
--  Local variables
----------------------------------------------------------------------

local bDebugMode = true;
TITAN_POINTS_ID = "Points";
TITAN_POINTS_VERSION = "4.0.1b1";
TITAN_NIL = false;
TITAN_POINTS_TAB_NUMBER = 3;	-- Currency Tab #

----------------------------------------------------------------------
--  TitanPanelPointsButton_OnLoad(self)
----------------------------------------------------------------------

function TitanPanelPointsButton_OnLoad(self)

	-- init realid_TimeCounter
	realid_TimeCounter = 0;

	self.registry = { 
		id = TITAN_POINTS_ID,
		version = TITAN_POINTS_VERSION,
		menuText = TITAN_POINTS_MENU_TEXT, 
		tooltipTitle = TITAN_POINTS_TOOLTIP,
		buttonTextFunction = "TitanPanelPointsButton_GetButtonText",
		tooltipTextFunction = "TitanPanelPointsButton_GetTooltipText",
		iconWidth = 16,
		icon = "Interface\\PVPFrame\\PVP-Currency-Alliance";
		category = "Information",
		controlVariables = {
			ShowIcon = true,
			DisplayOnRightSide = false
			--ShowRegularText = false,
			--ShowColoredText = true,
		},
		savedVariables = {       
			ShowValor = 1,
			ShowJustice = 1,
			ShowConquest = 1,
			ShowHonor = 1,
			ShowLabel = 1,
			ShowPointLabels = 1,
			ShowShortLabels = 0,
			ShowIcons = 1,
			ShowIcon = 1,
			ShowMem = 0,
		  }
	};


	-- Currency Events
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE");
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");

end



----------------------------------------------------------------------
--  TitanPanelPointsButton_OnEvent(self, event, ...)
--  Traps and deals with BN events ^^
----------------------------------------------------------------------

function TitanPanelPointsButton_OnEvent(self, event, ...)

	-- Debugging. Pay no attention to the man behind the curtain.
	if(bDebugMode) then
		if(event == "PLAYER_ENTERING_WORLD") then
			DEFAULT_CHAT_FRAME:AddMessage("Titan"..TITAN_POINTS_ID.." v"..TITAN_POINTS_VERSION.." Loaded.");
		end
		DEFAULT_CHAT_FRAME:AddMessage("Points: Caught Event "..event);
	end

	-- Update button label
	TitanPanelButton_UpdateButton(TITAN_POINTS_ID);	

end


----------------------------------------------------------------------
--  TitanPanelPointsButton_OnClick(self, button)
----------------------------------------------------------------------

function TitanPanelPointsButton_OnClick(self, button)

	if (button == "LeftButton") then
		if (not FriendsFrame:IsVisible()) then
			ToggleFriendsFrame(TITAN_POINTS_TAB_NUMBER);
			FriendsFrame_Update();
		elseif (FriendsFrame:IsVisible()) then
			ToggleFriendsFrame(TITAN_POINTS_TAB_NUMBER);
		end
	end
	
end

----------------------------------------------------------------------
--  TitanPanelRightClickMenu_PreparePointsMenu()
----------------------------------------------------------------------

function TitanPanelRightClickMenu_PreparePointsMenu()     
  
    local info = {};  
    TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_POINTS_ID].menuText);
    TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_VALOR, TITAN_POINTS_ID, "ShowValor");
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_JUSTICE, TITAN_POINTS_ID, "ShowJustice");
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_CONQUEST, TITAN_POINTS_ID, "ShowConquest");
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_HONOR, TITAN_POINTS_ID, "ShowHonor");
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_LABELS, TITAN_POINTS_ID, "ShowPointLabels");
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_SHORT_LABELS, TITAN_POINTS_ID, "ShowShortLabels");
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_POINTS_ID);
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_ICONS, TITAN_POINTS_ID, "ShowIcons");
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_MEM, TITAN_POINTS_ID, "ShowMem");
    TitanPanelRightClickMenu_AddSpacer();
    TitanPanelRightClickMenu_AddCommand("Hide", TITAN_POINTS_ID, TITAN_PANEL_MENU_FUNC_HIDE);
  
end

----------------------------------------------------------------------
--  TitanPanelPointsButton_OnUpdate()
----------------------------------------------------------------------

function TitanPanelPointsButton_OnUpdate(elapsed)
end


----------------------------------------------------------------------
-- TitanPanelPointsButton_GetButtonText(id)
----------------------------------------------------------------------

function TitanPanelPointsButton_GetButtonText(id)
	local id = TitanUtils_GetButton(id);
	local TITAN_POINTS_LIST_SIZE = GetCurrencyListSize();
	local TITAN_POINTS_LIST_INFO = nil;
	local buttonRichText = "";
	local TITAN_POINTS_LABEL_SIZE = 0;
	
	-- Label
	if (not TitanGetVar(TITAN_POINTS_ID,"ShowLabel") ~= nil) then
		TITAN_POINTS_BUTTON_LABEL = "";
	end
	
	-- GetCurrencyListInfo - Returns information about a currency type (or headers in the Currency UI)
	-- GetCurrencyListSize - Returns the number of list entries to show in the Currency UI
	
	if (TITAN_POINTS_LIST_SIZE > 0) then
	
		for CurrencyIndex=1, TITAN_POINTS_LIST_SIZE do
			
			-- Get Currency Info
			name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID = GetCurrencyListInfo(CurrencyIndex)

			-- If supported currency type
			if (name=="Valor Points") or (name=="Justice Points") or (name=="Conquest Points") or (name=="Honor Points") then
			
				-- Display point icon?
				if (TitanGetVar(TITAN_POINTS_ID,"ShowIcons") ~= nil) then
					-- Show currency icon from `icon' variable
					buttonRichText = buttonRichText.."[icon]";
				end
				
				-- Display Point Label?
				if (TitanGetVar(TITAN_POINTS_ID,"ShowPointLabels") ~= nil) then
					-- Display Short Labels?
					if(TitanGetVar(TITAN_POINTS_ID,"ShowShortLabels") ~= nil) then
						-- Short Labels
						--buttonRichText = buttonRichText..TitanUtils_GetNormalText("VP: ");
					else
						-- Normal Labels
						--buttonRichText = buttonRichText..TitanUtils_GetNormalText("Valor Points: ");
					end
				else
					--buttonRichText = buttonRichText.." ";
				end
				
				-- Valor Points
				if (name=="Valor Points") and (TitanGetVar(TITAN_POINTS_ID,"ShowValor") ~= nil) then
					local temp = nil;
					if(TitanGetVar(TITAN_POINTS_ID,"ShowPointLabels") ~= nil) then
						if (TitanGetVar(TITAN_POINTS_ID,"ShowShortLabels") ~= nil) then
							temp = format(TITAN_POINTS_LABEL_VALOR_SHORT,TitanUtils_GetHighlightText(count));
						else
							temp = format(TITAN_POINTS_LABEL_VALOR,TitanUtils_GetHighlightText(count));
						end
					else
						temp = format(TITAN_POINTS_LABEL_SPACER, TitanUtils_GetHighlightText(count));
					end
					buttonRichText = buttonRichText..temp;
				end
				
				-- Justice Points
				if (name=="Justice Points") and (TitanGetVar(TITAN_POINTS_ID,"ShowJustice") ~= nil) then
					local temp = nil;
					if(TitanGetVar(TITAN_POINTS_ID,"ShowPointLabels") ~= nil) then
						if (TitanGetVar(TITAN_POINTS_ID,"ShowShortLabels") ~= nil) then
							temp = format(TITAN_POINTS_LABEL_JUSTICE_SHORT,TitanUtils_GetHighlightText(count));
						else
							temp = format(TITAN_POINTS_LABEL_JUSTICE,TitanUtils_GetHighlightText(count));
						end
					else
						temp = format(TITAN_POINTS_LABEL_SPACER, TitanUtils_GetHighlightText(count));
					end
					buttonRichText = buttonRichText..temp;
				end
				
				-- Conquest Points
				if (name=="Conquest Points") and (TitanGetVar(TITAN_POINTS_ID,"ShowConquest") ~= nil) then
					local temp = nil;
					if(TitanGetVar(TITAN_POINTS_ID,"ShowPointLabels") ~= nil) then
						if (TitanGetVar(TITAN_POINTS_ID,"ShowShortLabels") ~= nil) then
							temp = format(TITAN_POINTS_LABEL_CONQUEST_SHORT,TitanUtils_GetHighlightText(count));
						else
							temp = format(TITAN_POINTS_LABEL_CONQUEST, TitanUtils_GetHighlightText(count));
						end
					else
						temp = format(TITAN_POINTS_LABEL_SPACER, TitanUtils_GetHighlightText(count));
					end
					buttonRichText = buttonRichText..temp;
				end
				
				-- Honor Points
				if (name=="Honor Points") and (TitanGetVar(TITAN_POINTS_ID,"ShowHonor") ~= nil) then
					local temp = nil;
					if(TitanGetVar(TITAN_POINTS_ID,"ShowPointLabels") ~= nil) then
						if (TitanGetVar(TITAN_POINTS_ID,"ShowShortLabels") ~= nil) then
							temp = format(TITAN_POINTS_LABEL_HONOR_SHORT,TitanUtils_GetHighlightText(count));
						else
							temp = format(TITAN_POINTS_LABEL_HONOR,TitanUtils_GetHighlightText(count));
						end
					else
						temp = format(TITAN_POINTS_LABEL_SPACER, TitanUtils_GetHighlightText(count));
					end
					buttonRichText = buttonRichText..temp;
				end
				
			end
		
		end
		
	end
	
	-- return button text
	return TITAN_POINTS_BUTTON_LABEL, buttonRichText;

end



----------------------------------------------------------------------
-- TitanPanelPointsButton_GetTooltipText()
----------------------------------------------------------------------

function TitanPanelPointsButton_GetTooltipText()

	local id = TitanUtils_GetButton(id);
	local TITAN_POINTS_LIST_SIZE = GetCurrencyListSize();
	local TITAN_POINTS_LIST_INFO = nil;
	local tooltipRichText = "";

	-- GetCurrencyListInfo - Returns information about a currency type (or headers in the Currency UI)
	-- GetCurrencyListSize - Returns the number of list entries to show in the Currency UI
	
	if (TITAN_POINTS_LIST_SIZE > 0) then
	
		for CurrencyIndex=1, TITAN_POINTS_LIST_SIZE do
			name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID = GetCurrencyListInfo(CurrencyIndex)
			
			if(not isHeader) then
				tooltipRichText = tooltipRichText..TitanUtils_GetHighlightText(name).."\t"..TitanUtils_GetHighlightText(count).."\n";
			else
				tooltipRichText = tooltipRichText.." \n"..TitanUtils_GetNormalText(name).."\n";
			end
		
		end
		
	end
	
	if (TitanGetVar(TITAN_POINTS_ID, "ShowMem") ~=nil) then
		tooltipRichText = tooltipRichText.." \nTitanPoints Memory Utilization:\t|cff00FF00"..floor(GetAddOnMemoryUsage( "TitanPoints")).." Kb|r";
	end
	
	-- return button text
	return tooltipRichText;

end