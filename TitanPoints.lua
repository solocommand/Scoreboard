

----------------------------------------------------------------------
--  Local variables
----------------------------------------------------------------------

local bDebugMode = false;
TITAN_POINTS_ID = "Points";
TITAN_POINTS_VERSION = "4.0.1b3";
TITAN_NIL = false;
TITAN_POINTS_TAB = "TokenFrame";	-- Currency Tab

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
			ShowShortLabels = false,
			ShowIcons = false,
			ShowIcon = 1,
			ShowMem = false,
			ShowHKs = false,
		  }
	};


	-- Currency Events
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE");
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");

end



----------------------------------------------------------------------
--  TitanPanelPointsButton_OnEvent(self, event, ...)
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
		ToggleCharacter(TITAN_POINTS_TAB);
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
	TitanPanelRightClickMenu_AddToggleVar(TITAN_POINTS_MENU_HKS, TITAN_POINTS_ID, "ShowHKs");
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
--  TitanPanelPoints_GetIcon(CurrencyType)
----------------------------------------------------------------------

function TitanPanelPoints_GetIcon(CurrencyType)
	local icon = nil;
	local faction = UnitFactionGroup( "player" );
	
	if (CurrencyType == TITAN_POINTS_VALOR) then
		--
	elseif (CurrencyType == TITAN_POINTS_JUSTICE) then
		--
	elseif (CurrencyType == TITAN_POINTS_CONQUEST) then
		if faction then
			icon = [[Interface\PVPFrame\PVPCurrency-Conquest-]]..faction;
		end
	elseif (CurrencyType == TITAN_POINTS_HONOR) then
		if faction then
			icon = [[Interface\PVPFrame\PVPCurrency-Honor-]]..faction;
		end
	end
	
	if not icon then
		icon = [[Interface\Icons\Temp]];
	end
	
	icon = "|T"..icon..":0|t ";
	--icon = "|T"..icon..":40:40:0:-3|t ";
	--icon = "|T"..icon..":16:16:0:0:64:64:4:60:4:60|t ";
	
	return icon;
	
end

----------------------------------------------------------------------
--  TitanPanelPoints_GetLabel(CurrencyType)
----------------------------------------------------------------------

function TitanPanelPoints_GetLabel(CurrencyType)
	local label = nil;
	local showLabels = TitanGetVar(TITAN_POINTS_ID, "ShowPointLabels");
	local shortLabels = TitanGetVar(TITAN_POINTS_ID, "ShowShortLabels");
	
	if (showLabels ~= nil) then
		if(shortLabels ~= nil) then
			if(CurrencyType==TITAN_POINTS_VALOR) and TitanGetVar(TITAN_POINTS_ID,"ShowValor") then
				label = TITAN_POINTS_LABEL_VALOR_SHORT;
			elseif(CurrencyType==TITAN_POINTS_JUSTICE) and TitanGetVar(TITAN_POINTS_ID,"ShowJustice") then
				label = TITAN_POINTS_LABEL_JUSTICE_SHORT;
			elseif(CurrencyType==TITAN_POINTS_CONQUEST) and TitanGetVar(TITAN_POINTS_ID,"ShowConquest") then
				label = TITAN_POINTS_LABEL_CONQUEST_SHORT;
			elseif(CurrencyType==TITAN_POINTS_HONOR) and TitanGetVar(TITAN_POINTS_ID,"ShowHonor") then
				label = TITAN_POINTS_LABEL_HONOR_SHORT;
			elseif(CurrencyType==TITAN_POINTS_HKS) and TitanGetVar(TITAN_POINTS_ID,"ShowHKs") then
				label = TITAN_POINTS_LABEL_HKS_SHORT;
			else
				label = TITAN_POINTS_LABEL_SPACER;
			end
		else
			if(CurrencyType==TITAN_POINTS_VALOR) and TitanGetVar(TITAN_POINTS_ID,"ShowValor") then
				label = TITAN_POINTS_LABEL_VALOR;
			elseif(CurrencyType==TITAN_POINTS_JUSTICE) and TitanGetVar(TITAN_POINTS_ID,"ShowJustice") then
				label = TITAN_POINTS_LABEL_JUSTICE;
			elseif(CurrencyType==TITAN_POINTS_CONQUEST) and TitanGetVar(TITAN_POINTS_ID,"ShowConquest") then
				label = TITAN_POINTS_LABEL_CONQUEST;
			elseif(CurrencyType==TITAN_POINTS_HONOR) and TitanGetVar(TITAN_POINTS_ID,"ShowHonor") then
				label = TITAN_POINTS_LABEL_HONOR;
			elseif(CurrencyType==TITAN_POINTS_HKS) and TitanGetVar(TITAN_POINTS_ID,"ShowHKs") then
				label = TITAN_POINTS_LABEL_HKS;
			else
				label = TITAN_POINTS_LABEL_SPACER;
			end
		end
	else
		label = TITAN_POINTS_LABEL_SPACER;
	end
	
	return label;
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

			-- Valor Points
			if (name==TITAN_POINTS_VALOR) and (TitanGetVar(TITAN_POINTS_ID,"ShowValor") ~= nil) then
				if(TitanGetVar(TITAN_POINTS_ID,"ShowIcons") ~= nil) then buttonRichText = buttonRichText..TitanPanelPoints_GetIcon(TITAN_POINTS_VALOR); end
				buttonRichText = buttonRichText..format(TitanPanelPoints_GetLabel(TITAN_POINTS_VALOR), TitanUtils_GetHighlightText(count));
			end
			
			-- Justice Points
			if (name==TITAN_POINTS_JUSTICE) and (TitanGetVar(TITAN_POINTS_ID,"ShowJustice") ~= nil) then
				if(TitanGetVar(TITAN_POINTS_ID,"ShowIcons") ~= nil) then buttonRichText = buttonRichText..TitanPanelPoints_GetIcon(TITAN_POINTS_JUSTICE); end
				buttonRichText = buttonRichText..format(TitanPanelPoints_GetLabel(TITAN_POINTS_JUSTICE), TitanUtils_GetHighlightText(count));
			end
			
			-- Conquest Points
			if (name==TITAN_POINTS_CONQUEST) and (TitanGetVar(TITAN_POINTS_ID,"ShowConquest") ~= nil) then
				if(TitanGetVar(TITAN_POINTS_ID,"ShowIcons") ~= nil) then buttonRichText = buttonRichText..TitanPanelPoints_GetIcon(TITAN_POINTS_CONQUEST); end
				buttonRichText = buttonRichText..format(TitanPanelPoints_GetLabel(TITAN_POINTS_CONQUEST), TitanUtils_GetHighlightText(count));
			end
			
			-- Honor Points
			if (name==TITAN_POINTS_HONOR) and (TitanGetVar(TITAN_POINTS_ID,"ShowHonor") ~= nil) then
				if(TitanGetVar(TITAN_POINTS_ID,"ShowIcons") ~= nil) then buttonRichText = buttonRichText..TitanPanelPoints_GetIcon(TITAN_POINTS_HONOR); end
				buttonRichText = buttonRichText..format(TitanPanelPoints_GetLabel(TITAN_POINTS_HONOR), TitanUtils_GetHighlightText(count));
			end
			
		end
		
	end
	
	if (TitanGetVar(TITAN_POINTS_ID, "ShowHKs") ~= nil) then
		-- Get Honor Kills
		HKs, null = GetPVPLifetimeStats()
		if(TitanGetVar(TITAN_POINTS_ID,"ShowIcons") ~= nil) then buttonRichText = buttonRichText..TitanPanelPoints_GetIcon(TITAN_POINTS_HKS); end
		buttonRichText = buttonRichText..format(TitanPanelPoints_GetLabel(TITAN_POINTS_HKS), TitanUtils_GetHighlightText(HKs));

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
	
	if (TitanGetVar(TITAN_POINTS_ID, "ShowHKs") ~= nil) then
		-- Get Honor Kills
		-- temp for testing: 999
		HKs, null = GetPVPLifetimeStats()
		tooltipRichText = tooltipRichText..TitanUtils_GetHighlightText(TITAN_POINTS_HKS).."\t"..TitanUtils_GetHighlightText(HKs).."\n";
		format(TitanPanelPoints_GetLabel(TITAN_POINTS_HKS), TitanUtils_GetHighlightText(HKs));
	end
	
	-- Get Honor Kills
	if (TitanGetVar(TITAN_POINTS_ID, "ShowMem") ~=nil) then
		tooltipRichText = tooltipRichText.." \n"..TITAN_POINTS_TOOLTIP_MEM.."\t|cff00FF00"..floor(GetAddOnMemoryUsage("TitanPoints")).." "..TITAN_POINTS_TOOLTIP_MEM_UNIT.."|r";
	end
	
	-- return button text
	return tooltipRichText;

end