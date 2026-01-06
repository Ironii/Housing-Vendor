-- Reputation UI
-- Multi-character reputation tracking panel

local _, ns = ...
local L = (ns and ns.L) or _G["HousingVendorL"] or {}

local ReputationUI = {}
ReputationUI.__index = ReputationUI

ReputationUI._reputationContainer = ReputationUI._reputationContainer or nil
ReputationUI._parentFrame = ReputationUI._parentFrame or nil
ReputationUI._currentFontSize = ReputationUI._currentFontSize or 12
ReputationUI._fontStrings = ReputationUI._fontStrings or {}
ReputationUI._scrollFrame = ReputationUI._scrollFrame or nil
ReputationUI._scrollChild = ReputationUI._scrollChild or nil
ReputationUI._searchText = ReputationUI._searchText or ""
ReputationUI._filterExpansion = ReputationUI._filterExpansion or "All"
ReputationUI._filterCategory = ReputationUI._filterCategory or "All"
ReputationUI._selectedCharacter = ReputationUI._selectedCharacter or nil
ReputationUI._expandedReputations = ReputationUI._expandedReputations or {}

local function SetNavButtonsVisible(visible)
    local buttons = _G["HousingNavButtons"]
    if type(buttons) ~= "table" then
        return
    end
    for _, btn in ipairs(buttons) do
        if btn and btn.SetShown then
            btn:SetShown(visible)
        end
    end
end

local modelViewerWasVisible = false

local function SetMainUIVisible(visible)
    if _G["HousingFilterFrame"] then
        _G["HousingFilterFrame"]:SetShown(visible)
    end
    if _G["HousingItemListScrollFrame"] then
        _G["HousingItemListScrollFrame"]:SetShown(visible)
    end
    if _G["HousingItemListContainer"] then
        _G["HousingItemListContainer"]:SetShown(visible)
    end
    if _G["HousingItemListHeader"] then
        _G["HousingItemListHeader"]:SetShown(visible)
    end
    if _G["HousingPreviewFrame"] then
        _G["HousingPreviewFrame"]:SetShown(visible)
    end
    local modelFrame = _G["HousingModelViewerFrame"]
    if not visible then
        modelViewerWasVisible = modelFrame and modelFrame:IsShown() or false
        if modelFrame then
            modelFrame:Hide()
        elseif _G["HousingModelViewer"] and _G["HousingModelViewer"].Hide then
            _G["HousingModelViewer"]:Hide()
        end
    elseif modelViewerWasVisible and modelFrame then
        modelFrame:Show()
    end
    SetNavButtonsVisible(visible)
end

local function BuildReputationVendorIndex()
    local map = {}
    if not HousingVendorItemToFaction or not HousingExpansionData then
        return map
    end

    for itemID, repInfo in pairs(HousingVendorItemToFaction) do
        local factionID = repInfo and repInfo.factionID
        if factionID then
            local factionKey = tostring(factionID)
            local itemData = HousingExpansionData[itemID]
            local vd = itemData and itemData.vendor and itemData.vendor.vendorDetails or nil
            if vd then
                local vendorName = vd.vendorName or vd.name
                if vendorName and vendorName ~= "" and vendorName ~= "None" then
                    local location = vd.location or vd.zone or nil
                    local expansion = vd.expansion or nil
                    map[factionKey] = map[factionKey] or { vendors = {}, order = {} }
                    local key = (vendorName or "") .. "|" .. (location or "") .. "|" .. (expansion or "")
                    if not map[factionKey].vendors[key] then
                        local entry = { name = vendorName, location = location, expansion = expansion }
                        map[factionKey].vendors[key] = entry
                        table.insert(map[factionKey].order, entry)
                    end
                end
            end
        end
    end

    return map
end

-- Initialize reputation UI
function ReputationUI:Initialize(parent)
    self._parentFrame = parent
    -- Load saved font size
    self._currentFontSize = (HousingDB and HousingDB.fontSize) or 12

    -- Set selected character to current character
    if HousingReputationHandler then
        self._selectedCharacter = HousingReputationHandler:GetCurrentCharacter()
    end
end

-- Create reputation container
function ReputationUI:CreateReputationContainer()
    if self._reputationContainer then
        return self._reputationContainer
    end

    local parentFrame = self._parentFrame
    if not parentFrame then
        return nil
    end

    local currentFontSize = self._currentFontSize or 12
    local fontStrings = self._fontStrings or {}
    self._fontStrings = fontStrings

    -- Create container that will replace the item list and filters
    local container = CreateFrame("Frame", "HousingVendorReputationContainer", parentFrame)
    container:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 20, -70)
    container:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -20, 52)
    container:Hide()

    -- Back button (Midnight theme styled)
    local theme = HousingTheme or {}
    local bgTertiary = theme.Colors.bgTertiary or {0.1, 0.1, 0.1, 1}
    local borderPrimary = theme.Colors.borderPrimary or {0.3, 0.3, 0.3, 1}
    local bgHover = theme.Colors.bgHover or {0.2, 0.2, 0.2, 1}
    local accentPrimary = theme.Colors.accentPrimary or {0.8, 0.6, 0.2, 1}
    local textPrimary = theme.Colors.textPrimary or {1, 1, 1, 1}
    local textHighlight = theme.Colors.textHighlight or {1, 0.82, 0, 1}

    local backBtn = CreateFrame("Button", nil, container, "BackdropTemplate")
    backBtn:SetSize(80, 28)
    backBtn:SetPoint("TOPLEFT", 10, -10)
    backBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    backBtn:SetBackdropColor(bgTertiary[1], bgTertiary[2], bgTertiary[3], bgTertiary[4])
    backBtn:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])

    local backBtnText = backBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    backBtnText:SetPoint("CENTER")
    backBtnText:SetText(L["BUTTON_BACK"] or "Back")
    backBtnText:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    backBtn.label = backBtnText

    backBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], bgHover[4])
        self:SetBackdropBorderColor(accentPrimary[1], accentPrimary[2], accentPrimary[3], 1)
        self.label:SetTextColor(textHighlight[1], textHighlight[2], textHighlight[3], 1)
    end)
    backBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(bgTertiary[1], bgTertiary[2], bgTertiary[3], bgTertiary[4])
        self:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])
        self.label:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    end)
    backBtn:SetScript("OnClick", function()
        ReputationUI:Hide()
    end)

    -- Title
    local title = container:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    local titleFont, titleSize, titleFlags = title:GetFont()
    if currentFontSize ~= 12 then
        title:SetFont(titleFont, currentFontSize + 4, titleFlags)
    end
    title:SetText("|cFFFFD700Housing Reputations|r")
    table.insert(fontStrings, title)

    -- Filter and search row
    local filterSearchFrame = CreateFrame("Frame", nil, container)
    filterSearchFrame:SetSize(container:GetWidth() - 40, 32)
    filterSearchFrame:SetPoint("TOP", title, "BOTTOM", 0, -15)

    -- Expansion filter (left side)
    local expFilterBtn = CreateFrame("Button", nil, filterSearchFrame, "BackdropTemplate")
    expFilterBtn:SetSize(180, 28)
    expFilterBtn:SetPoint("LEFT", 0, 0)
    expFilterBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    expFilterBtn:SetBackdropColor(bgTertiary[1], bgTertiary[2], bgTertiary[3], bgTertiary[4])
    expFilterBtn:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])

    local expFilterText = expFilterBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    expFilterText:SetPoint("CENTER")
    expFilterText:SetText("Expansion: All")
    expFilterText:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    expFilterBtn.label = expFilterText

    expFilterBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], bgHover[4])
        self:SetBackdropBorderColor(accentPrimary[1], accentPrimary[2], accentPrimary[3], 1)
    end)
    expFilterBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(bgTertiary[1], bgTertiary[2], bgTertiary[3], bgTertiary[4])
        self:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])
    end)
    expFilterBtn:SetScript("OnClick", function(self)
        ReputationUI:ShowExpansionFilterMenu(self)
    end)
    container.expFilterBtn = expFilterBtn

    -- Category filter (next to expansion)
    local catFilterBtn = CreateFrame("Button", nil, filterSearchFrame, "BackdropTemplate")
    catFilterBtn:SetSize(180, 28)
    catFilterBtn:SetPoint("LEFT", expFilterBtn, "RIGHT", 10, 0)
    catFilterBtn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    catFilterBtn:SetBackdropColor(bgTertiary[1], bgTertiary[2], bgTertiary[3], bgTertiary[4])
    catFilterBtn:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])

    local catFilterText = catFilterBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    catFilterText:SetPoint("CENTER")
    catFilterText:SetText("Category: All")
    catFilterText:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    catFilterBtn.label = catFilterText

    catFilterBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], bgHover[4])
        self:SetBackdropBorderColor(accentPrimary[1], accentPrimary[2], accentPrimary[3], 1)
    end)
    catFilterBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(bgTertiary[1], bgTertiary[2], bgTertiary[3], bgTertiary[4])
        self:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])
    end)
    catFilterBtn:SetScript("OnClick", function(self)
        ReputationUI:ShowCategoryFilterMenu(self)
    end)
    container.catFilterBtn = catFilterBtn

    -- Search bar (right side, aligned)
    local searchFrame = CreateFrame("Frame", nil, filterSearchFrame, "BackdropTemplate")
    searchFrame:SetSize(300, 28)
    searchFrame:SetPoint("RIGHT", 0, 0)
    searchFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    searchFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
    searchFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    local searchBox = CreateFrame("EditBox", nil, searchFrame)
    searchBox:SetSize(280, 24)
    searchBox:SetPoint("LEFT", 5, 0)
    searchBox:SetFontObject("GameFontNormal")
    searchBox:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(50)
    searchBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    searchBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    searchBox:SetScript("OnTextChanged", function(self, userInput)
        if userInput then
            ReputationUI._searchText = self:GetText():lower()
            ReputationUI:Refresh()
        end
    end)
    container.searchBox = searchBox

    local searchPlaceholder = searchFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    searchPlaceholder:SetPoint("LEFT", searchBox, "LEFT", 5, 0)
    searchPlaceholder:SetText("|cFF808080Search reputations...|r")
    searchPlaceholder:SetJustifyH("LEFT")
    searchBox:SetScript("OnEditFocusGained", function() searchPlaceholder:Hide() end)
    searchBox:SetScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then
            searchPlaceholder:Show()
        end
    end)

    -- Summary section
    local summaryFrame = CreateFrame("Frame", nil, container, "BackdropTemplate")
    summaryFrame:SetSize(container:GetWidth() - 40, 50)
    summaryFrame:SetPoint("TOP", filterSearchFrame, "BOTTOM", 0, -10)
    summaryFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    summaryFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
    summaryFrame:SetBackdropBorderColor(accentPrimary[1], accentPrimary[2], accentPrimary[3], 0.5)

    container.summaryFrame = summaryFrame

    -- Scroll frame for reputation list
    local scrollFrame = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", summaryFrame, "BOTTOMLEFT", 0, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -30, 10)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)

    self._scrollFrame = scrollFrame
    self._scrollChild = scrollChild

    self._reputationContainer = container
    return container
end

-- Show expansion filter menu
function ReputationUI:ShowExpansionFilterMenu(button)
    local menu = CreateFrame("Frame", nil, button, "BackdropTemplate")
    menu:SetFrameStrata("DIALOG")
    menu:SetFrameLevel(200)
    menu:SetSize(200, 400)
    menu:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, -2)
    menu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    menu:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
    menu:SetBackdropBorderColor(0.8, 0.6, 0.2, 1)

    local scrollFrame = CreateFrame("ScrollFrame", nil, menu, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -5)
    scrollFrame:SetPoint("BOTTOMRIGHT", -25, 5)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)

    -- Get unique expansions
    local expansions = { "All" }
    local seen = {}

    if HousingReputationHandler then
        local reputationList = HousingReputationHandler:GetReputations(self._selectedCharacter)
        for _, repData in ipairs(reputationList) do
            local exp = repData.expansion or "Unknown"
            if not seen[exp] then
                seen[exp] = true
                table.insert(expansions, exp)
            end
        end
    end

    local yOffset = -5
    for _, exp in ipairs(expansions) do
        local btn = CreateFrame("Button", nil, scrollChild, "BackdropTemplate")
        btn:SetSize(165, 25)
        btn:SetPoint("TOPLEFT", 5, yOffset)
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            tile = false,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        btn:SetBackdropColor(0.15, 0.15, 0.15, 1)

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", 8, 0)
        text:SetText(exp)
        if exp == self._filterExpansion then
            text:SetTextColor(1, 0.82, 0, 1)
        else
            text:SetTextColor(1, 1, 1, 1)
        end

        btn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.25, 0.25, 0.25, 1) end)
        btn:SetScript("OnLeave", function(self) self:SetBackdropColor(0.15, 0.15, 0.15, 1) end)
        btn:SetScript("OnClick", function()
            ReputationUI._filterExpansion = exp
            ReputationUI._reputationContainer.expFilterBtn.label:SetText("Expansion: " .. exp)
            ReputationUI:Refresh()
            menu:Hide()
        end)

        yOffset = yOffset - 30
    end

    scrollChild:SetHeight(math.abs(yOffset))

    menu:SetScript("OnHide", function(self) self:SetParent(nil) end)
    menu:Show()

    -- Click outside to close
    menu:SetScript("OnUpdate", function(self)
        if not self:IsMouseOver() and not button:IsMouseOver() then
            self:Hide()
        end
    end)
end

-- Show category filter menu
function ReputationUI:ShowCategoryFilterMenu(button)
    local menu = CreateFrame("Frame", nil, button, "BackdropTemplate")
    menu:SetFrameStrata("DIALOG")
    menu:SetFrameLevel(200)
    menu:SetSize(200, 300)
    menu:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, -2)
    menu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    menu:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
    menu:SetBackdropBorderColor(0.8, 0.6, 0.2, 1)

    local scrollFrame = CreateFrame("ScrollFrame", nil, menu, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -5)
    scrollFrame:SetPoint("BOTTOMRIGHT", -25, 5)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)

    -- Get unique categories
    local categories = { "All" }
    local seen = {}

    if HousingReputationHandler then
        local reputationList = HousingReputationHandler:GetReputations(self._selectedCharacter)
        for _, repData in ipairs(reputationList) do
            local cat = repData.category or "Unknown"
            if not seen[cat] then
                seen[cat] = true
                table.insert(categories, cat)
            end
        end
    end

    -- Sort categories alphabetically (except "All" stays first)
    table.sort(categories, function(a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)

    local yOffset = -5
    for _, cat in ipairs(categories) do
        local btn = CreateFrame("Button", nil, scrollChild, "BackdropTemplate")
        btn:SetSize(165, 25)
        btn:SetPoint("TOPLEFT", 5, yOffset)
        btn:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            tile = false,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        btn:SetBackdropColor(0.15, 0.15, 0.15, 1)

        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", 8, 0)
        text:SetText(cat)
        if cat == self._filterCategory then
            text:SetTextColor(1, 0.82, 0, 1)
        else
            text:SetTextColor(1, 1, 1, 1)
        end

        btn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.25, 0.25, 0.25, 1) end)
        btn:SetScript("OnLeave", function(self) self:SetBackdropColor(0.15, 0.15, 0.15, 1) end)
        btn:SetScript("OnClick", function()
            ReputationUI._filterCategory = cat
            ReputationUI._reputationContainer.catFilterBtn.label:SetText("Category: " .. cat)
            ReputationUI:Refresh()
            menu:Hide()
        end)

        yOffset = yOffset - 30
    end

    scrollChild:SetHeight(math.abs(yOffset))

    menu:SetScript("OnHide", function(self) self:SetParent(nil) end)
    menu:Show()

    -- Click outside to close
    menu:SetScript("OnUpdate", function(self)
        if not self:IsMouseOver() and not button:IsMouseOver() then
            self:Hide()
        end
    end)
end

-- Refresh reputation list
function ReputationUI:Refresh()
    if not self._reputationContainer or not self._scrollChild then
        return
    end

    local container = self._reputationContainer
    local scrollChild = self._scrollChild
    local summaryFrame = container.summaryFrame

    -- Clear existing reputation frames
    if scrollChild.reputations then
        for _, frame in ipairs(scrollChild.reputations) do
            frame:Hide()
            frame:SetParent(nil)
        end
    end
    scrollChild.reputations = {}

    if not HousingReputationHandler then
        return
    end

    -- Get reputation list (live data for current character)
    local reputationList = HousingReputationHandler:GetReputations()

    if not reputationList or #reputationList == 0 then
        -- Show "no data" message
        local noDataText = summaryFrame.noDataText or summaryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        summaryFrame.noDataText = noDataText
        noDataText:SetPoint("CENTER", scrollChild, "CENTER", 0, 0)
        noDataText:SetText("|cFFFF8040No reputation data available.|r")

        if summaryFrame.text then
            summaryFrame.text:Hide()
        end
        return
    end

    -- Hide no data message if it exists
    if summaryFrame.noDataText then
        summaryFrame.noDataText:Hide()
    end
    if summaryFrame.text then
        summaryFrame.text:Show()
    end

    -- Filter reputations
    local filteredList = {}
    for _, repData in ipairs(reputationList) do
        local expansion = repData.expansion or "Unknown"
        local category = repData.category or "Unknown"

        local matchesExpansion = (self._filterExpansion == "All" or expansion == self._filterExpansion)
        local matchesCategory = (self._filterCategory == "All" or category == self._filterCategory)
        local matchesSearch = (self._searchText == "" or
            (repData.label and string.find(repData.label:lower(), self._searchText, 1, true)))

        if matchesExpansion and matchesCategory and matchesSearch then
            table.insert(filteredList, repData)
        end
    end

    -- Update summary
    local summaryText = summaryFrame.text or summaryFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    summaryFrame.text = summaryText
    summaryText:SetPoint("CENTER")
    summaryText:SetJustifyH("CENTER")

    local charName = (self._selectedCharacter and self._selectedCharacter:match("^([^-]+)")) or "Current"
    summaryText:SetText(string.format(
        "|cFFFFD700%d|r factions for |cFF00CCFF%s|r",
        #filteredList, charName
    ))

    -- Display reputations
    local yOffset = -10
    local reputations = {}
    local theme = HousingTheme or {}
    local accentPrimary = theme.Colors.accentPrimary or {0.8, 0.6, 0.2, 1}
    local bgHover = theme.Colors.bgHover or {0.2, 0.2, 0.2, 1}
    local repVendorIndex = BuildReputationVendorIndex()

    for _, repData in ipairs(filteredList) do
        -- Check if this reputation is expanded
        local isExpanded = self._expandedReputations[repData.factionID]

        -- Reputation card (increased height to fit faction details)
        local repFrame = CreateFrame("Button", nil, scrollChild, "BackdropTemplate")
        local extraLines = 0
        if repData.isRenown then
            extraLines = extraLines + 1
        end
        local vendorLine = nil
        local vendorInfo = repVendorIndex[tostring(repData.factionID)]
        if vendorInfo and vendorInfo.order and #vendorInfo.order > 0 then
            local maxVendors = 2
            local parts = {}
            for i, v in ipairs(vendorInfo.order) do
                if i > maxVendors then
                    break
                end
                local label = v.name or "Unknown"
                if v.location and v.location ~= "" and v.location ~= "None" then
                    label = label .. " (" .. v.location .. ")"
                end
                table.insert(parts, label)
            end
            vendorLine = "Vendors: " .. table.concat(parts, "; ")
            if #vendorInfo.order > maxVendors then
                vendorLine = vendorLine .. string.format(" +%d more", #vendorInfo.order - maxVendors)
            end
            extraLines = extraLines + 1
        end

        -- Calculate height based on expanded state
        local baseHeight = 70 + (extraLines * 16)
        local expandedHeight = 0
        if isExpanded then
            -- Add height for detailed information (Faction ID, Expansion, Category, Type, Standing)
            expandedHeight = 140

            -- Add height for progress info (Current Progress line)
            if repData.currentValue and repData.maxValue then
                expandedHeight = expandedHeight + 18

                -- Add height for "To Next Level" line
                if (not repData.isRenown and repData.standingLevel and repData.standingLevel < 8) or
                   (repData.isRenown and repData.currentValue < repData.maxValue) or
                   ((not repData.isRenown and repData.standingLevel == 8) or (repData.isRenown and repData.currentValue >= repData.maxValue)) then
                    expandedHeight = expandedHeight + 18
                end
            end

            -- Add spacing before vendors
            expandedHeight = expandedHeight + 4

            -- Add height for each vendor if there are vendors
            if vendorInfo and vendorInfo.order and #vendorInfo.order > 0 then
                expandedHeight = expandedHeight + (#vendorInfo.order * 20) + 22
            end
        end
        local repHeight = baseHeight + expandedHeight
        repFrame:SetSize(scrollChild:GetWidth() - 20, repHeight)
        repFrame:SetPoint("TOPLEFT", 10, yOffset)
        repFrame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            tile = false, edgeSize = 1,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        repFrame:SetBackdropColor(0.08, 0.08, 0.08, 0.9)
        repFrame:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)

        -- Make clickable
        repFrame:EnableMouse(true)
        repFrame:SetScript("OnEnter", function(self)
            self:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], 0.9)

            -- Show tooltip with vendor information
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            GameTooltip:AddLine(repData.label or "Unknown", 1, 0.82, 0, true)
            GameTooltip:AddLine(" ")

            -- Add vendor information
            local vendorInfo = repVendorIndex[tostring(repData.factionID)]
            if vendorInfo and vendorInfo.order and #vendorInfo.order > 0 then
                GameTooltip:AddLine("Vendors:", 0.8, 0.8, 0.8, true)
                for i, v in ipairs(vendorInfo.order) do
                    local vendorText = v.name or "Unknown"
                    if v.location and v.location ~= "" and v.location ~= "None" then
                        vendorText = vendorText .. " (" .. v.location .. ")"
                    end
                    GameTooltip:AddLine("  " .. vendorText, 1, 1, 1, true)
                end
            else
                GameTooltip:AddLine("No vendors found", 0.6, 0.6, 0.6, true)
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Click for more details", 0.5, 0.8, 1, true)
            GameTooltip:Show()
        end)
        repFrame:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.08, 0.08, 0.08, 0.9)
            GameTooltip:Hide()
        end)
        repFrame:SetScript("OnClick", function()
            -- Toggle expanded state
            self._expandedReputations[repData.factionID] = not self._expandedReputations[repData.factionID]
            -- Refresh to show/hide details
            self:Refresh()
        end)

        -- Faction icon (using generic rep icon)
        local icon = repFrame:CreateTexture(nil, "ARTWORK")
        icon:SetSize(40, 40)
        icon:SetPoint("TOPLEFT", 10, -10)
        icon:SetTexture("Interface\\Icons\\Achievement_Reputation_01")

        -- Faction name
        local nameText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 12, -2)
        nameText:SetPoint("RIGHT", -150, 0)
        nameText:SetJustifyH("LEFT")
        nameText:SetWordWrap(false)
        nameText:SetText("|cFFFFFFFF" .. repData.label .. "|r")

        -- Faction details (ID, expansion, and category)
        local detailsText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        detailsText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
        detailsText:SetJustifyH("LEFT")
        local expansion = repData.expansion or "Unknown"
        local category = repData.category or "Unknown"

        -- Get reputation requirement for items from this faction
        local reqText = ""
        if HousingVendorItemToFaction then
            for itemID, repInfo in pairs(HousingVendorItemToFaction) do
                if tonumber(repInfo.factionID) == repData.factionID and repInfo.requiredStanding then
                    reqText = " |cFF808080-|r |cFFFFD700Requires: " .. repInfo.requiredStanding .. "|r"
                    break  -- Just need one example
                end
            end
        end

        detailsText:SetText("|cFF808080Faction ID:|r " .. repData.factionID .. " |cFF808080(|r" .. expansion .. "|cFF808080)|r |cFF808080-|r |cFF00CCFF" .. category .. "|r" .. reqText)

        -- Standing
        local standingText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        standingText:SetPoint("TOPRIGHT", -10, -10)

        -- Color code standing
        local standingColor = "|cFF00FF00"  -- Green for max level
        if repData.standing == "Not Discovered" then
            standingColor = "|cFFFF6600"  -- Orange for not discovered
        elseif repData.standing:find("Exalted") or repData.standing:find("Renown") then
            standingColor = "|cFFFFD700"  -- Gold for Exalted/Renown
        elseif repData.standing:find("Revered") then
            standingColor = "|cFF00FF00"  -- Green
        elseif repData.standing:find("Honored") or repData.standing:find("Friendly") then
            standingColor = "|cFF00CCFF"  -- Cyan
        else
            standingColor = "|cFFCCCCCC"  -- Gray
        end

        standingText:SetText(standingColor .. repData.standing .. "|r")

        -- Account-wide indicator for Renown
        local detailAnchor = detailsText
        if repData.isRenown then
            local accountText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            accountText:SetPoint("TOPLEFT", detailsText, "BOTTOMLEFT", 0, -2)
            accountText:SetText("|cFF00CCFFAccount-wide|r")
            detailAnchor = accountText
        end

        if vendorLine then
            local vendorText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            vendorText:SetPoint("TOPLEFT", detailAnchor, "BOTTOMLEFT", 0, -2)
            vendorText:SetPoint("RIGHT", -10, 0)
            vendorText:SetJustifyH("LEFT")
            vendorText:SetWordWrap(true)
            vendorText:SetText(vendorLine)
        end

        -- Progress bar (only show if discovered)
        if repData.standing ~= "Not Discovered" and repData.currentValue and repData.maxValue and repData.maxValue > 0 then
            local progressBg = repFrame:CreateTexture(nil, "BACKGROUND")
            progressBg:SetSize(repFrame:GetWidth() - 70, 12)
            progressBg:SetPoint("BOTTOMLEFT", repFrame, "BOTTOMLEFT", 62, 10)
            progressBg:SetColorTexture(0.2, 0.2, 0.2, 0.8)

            local progress = math.min(repData.currentValue / repData.maxValue, 1)
            local progressBar = repFrame:CreateTexture(nil, "ARTWORK")
            progressBar:SetSize((repFrame:GetWidth() - 70) * progress, 12)
            progressBar:SetPoint("LEFT", progressBg, "LEFT", 0, 0)

            if progress >= 1 then
                progressBar:SetColorTexture(0, 0.8, 0, 0.8)  -- Green for max
            else
                progressBar:SetColorTexture(accentPrimary[1], accentPrimary[2], accentPrimary[3], 0.8)
            end

            local progressText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            progressText:SetPoint("LEFT", progressBg, "RIGHT", 8, 0)
            local percentage = math.floor(progress * 100)
            progressText:SetText(string.format("%d/%d (%d%%)", repData.currentValue, repData.maxValue, percentage))
        elseif repData.standing == "Not Discovered" then
            -- Show a message for not discovered factions
            local notDiscoveredText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            notDiscoveredText:SetPoint("BOTTOMLEFT", repFrame, "BOTTOMLEFT", 62, 10)
            notDiscoveredText:SetText("|cFFFF6600Faction not yet discovered - Visit the zone to unlock|r")
        end

        -- Expand arrow indicator
        local arrow = repFrame:CreateTexture(nil, "OVERLAY")
        arrow:SetSize(16, 16)
        arrow:SetPoint("BOTTOMRIGHT", -10, 10)

        if isExpanded then
            -- Down arrow for expanded state
            arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
            arrow:SetVertexColor(1, 0.82, 0, 1)  -- Gold color
        else
            -- Right arrow for collapsed state
            arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Up")
            arrow:SetRotation(math.rad(180))  -- Rotate to point right
            arrow:SetVertexColor(0.5, 0.5, 0.5, 1)  -- Gray color
        end

        -- Expanded details section
        if isExpanded then
            -- Calculate starting position for expanded content (below progress bar)
            local detailsYOffset = -70

            -- Detailed information section
            local detailsHeader = repFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
            detailsHeader:SetPoint("TOPLEFT", 20, detailsYOffset)
            detailsHeader:SetText("|cFFFFD700Reputation Details|r")
            detailsYOffset = detailsYOffset - 22

            -- Faction ID
            local factionIDText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            factionIDText:SetPoint("TOPLEFT", 30, detailsYOffset)
            factionIDText:SetText("|cFF808080Faction ID:|r " .. (repData.factionID or "Unknown"))
            detailsYOffset = detailsYOffset - 18

            -- Expansion
            local expansionText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            expansionText:SetPoint("TOPLEFT", 30, detailsYOffset)
            expansionText:SetText("|cFF808080Expansion:|r " .. (repData.expansion or "Unknown"))
            detailsYOffset = detailsYOffset - 18

            -- Category
            local categoryText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            categoryText:SetPoint("TOPLEFT", 30, detailsYOffset)
            categoryText:SetText("|cFF808080Category:|r " .. (repData.category or "Unknown"))
            detailsYOffset = detailsYOffset - 18

            -- Type (Renown or Standard)
            local typeText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            typeText:SetPoint("TOPLEFT", 30, detailsYOffset)
            if repData.isRenown then
                typeText:SetText("|cFF808080Type:|r Renown (Account-wide)")
            else
                typeText:SetText("|cFF808080Type:|r Standard Reputation")
            end
            detailsYOffset = detailsYOffset - 18

            -- Standing
            local standingDetailText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            standingDetailText:SetPoint("TOPLEFT", 30, detailsYOffset)
            standingDetailText:SetText("|cFF808080Standing:|r " .. (repData.standing or "Unknown"))
            detailsYOffset = detailsYOffset - 18

            -- Current Progress (only show if not "Not Discovered")
            if repData.standing ~= "Not Discovered" and repData.currentValue and repData.maxValue then
                local progressDetailText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                progressDetailText:SetPoint("TOPLEFT", 30, detailsYOffset)
                local percentage = math.floor((repData.currentValue / repData.maxValue) * 100)
                progressDetailText:SetText("|cFF808080Current Progress:|r " .. repData.currentValue .. " / " .. repData.maxValue .. " (" .. percentage .. "%)")
                detailsYOffset = detailsYOffset - 18

                -- Reputation needed for next level
                if not repData.isRenown and repData.standingLevel and repData.standingLevel < 8 then
                    -- Calculate standing levels
                    local STANDING_NAMES = {
                        [1] = "Hated",
                        [2] = "Hostile",
                        [3] = "Unfriendly",
                        [4] = "Neutral",
                        [5] = "Friendly",
                        [6] = "Honored",
                        [7] = "Revered",
                        [8] = "Exalted",
                    }

                    local nextLevel = repData.standingLevel + 1
                    local nextStandingName = STANDING_NAMES[nextLevel]
                    local repNeeded = repData.maxValue - repData.currentValue

                    local nextLevelText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    nextLevelText:SetPoint("TOPLEFT", 30, detailsYOffset)
                    nextLevelText:SetText("|cFF808080To " .. nextStandingName .. ":|r " .. repNeeded .. " more reputation")
                    detailsYOffset = detailsYOffset - 18
                elseif repData.isRenown and repData.currentValue < repData.maxValue then
                    -- For renown, show progress to max renown
                    local renownNeeded = repData.maxValue - repData.currentValue
                    local nextRenownText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    nextRenownText:SetPoint("TOPLEFT", 30, detailsYOffset)
                    nextRenownText:SetText("|cFF808080To Max Renown:|r " .. renownNeeded .. " more levels")
                    detailsYOffset = detailsYOffset - 18
                elseif (not repData.isRenown and repData.standingLevel == 8) or (repData.isRenown and repData.currentValue >= repData.maxValue) then
                    -- Max level reached
                    local maxLevelText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    maxLevelText:SetPoint("TOPLEFT", 30, detailsYOffset)
                    maxLevelText:SetText("|cFF00FF00Maximum reputation level reached!|r")
                    detailsYOffset = detailsYOffset - 18
                end
            end

            detailsYOffset = detailsYOffset - 4

            -- Vendors section
            if vendorInfo and vendorInfo.order and #vendorInfo.order > 0 then
                local vendorsHeader = repFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                vendorsHeader:SetPoint("TOPLEFT", 20, detailsYOffset)
                vendorsHeader:SetText("|cFFFFD700Vendors|r")
                detailsYOffset = detailsYOffset - 22

                for i, v in ipairs(vendorInfo.order) do
                    local vendorEntryText = repFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    vendorEntryText:SetPoint("TOPLEFT", 30, detailsYOffset)
                    vendorEntryText:SetPoint("RIGHT", -20, 0)
                    vendorEntryText:SetJustifyH("LEFT")
                    local vendorLabel = v.name or "Unknown"
                    if v.location and v.location ~= "" and v.location ~= "None" then
                        vendorLabel = vendorLabel .. " |cFF808080(|r" .. v.location .. "|cFF808080)|r"
                    end
                    vendorEntryText:SetText("• " .. vendorLabel)
                    detailsYOffset = detailsYOffset - 20
                end
            end

            -- Add background for expanded section now that we know the size
            local detailsBg = repFrame:CreateTexture(nil, "BACKGROUND", nil, -1)
            detailsBg:SetPoint("TOPLEFT", 10, -68)
            detailsBg:SetPoint("BOTTOMRIGHT", -10, math.max(detailsYOffset - 5, -repHeight + 5))
            detailsBg:SetColorTexture(0, 0, 0, 0.3)
        end

        table.insert(reputations, repFrame)
        yOffset = yOffset - (repHeight + 8)
    end

    scrollChild.reputations = reputations
    scrollChild:SetHeight(math.abs(yOffset) + 20)
end

-- Show reputation UI
function ReputationUI:Show()
    local container = self._reputationContainer or self:CreateReputationContainer()
    if not container then
        return
    end

    -- Hide other UI panels
    if HousingAchievementsUI and HousingAchievementsUI.Hide then
        HousingAchievementsUI:Hide()
    end
    if HousingStatisticsUI and HousingStatisticsUI.Hide then
        HousingStatisticsUI:Hide()
    end
    if HousingAuctionHouseUI and HousingAuctionHouseUI.Hide then
        HousingAuctionHouseUI:Hide()
    end

    -- Hide main UI components and nav buttons
    SetMainUIVisible(false)

    -- Refresh and show
    self:Refresh()
    container:Show()
end

-- Hide reputation UI
function ReputationUI:Hide()
    if self._reputationContainer then
        self._reputationContainer:Hide()
    end

    -- Show main UI components and nav buttons again
    SetMainUIVisible(true)
end

-- Make globally accessible
_G.HousingReputationUI = ReputationUI

return ReputationUI
