-- CompactUI.lua
-- Standalone Compact UI frame (separate from HousingFrameNew).

local ADDON_NAME, ns = ...
local L = ns.L

local CompactUI = {}
CompactUI.__index = CompactUI

local frame = nil
local list = nil
local navBar = nil
local planBtn = nil
local planListenerRegistered = false
local isSwitchingToFullUI = false

local function EnsureListButtonListener()
    if planListenerRegistered then
        return
    end

    local pm = _G.HousingPlanManager
    if not (pm and pm.RegisterListener) then
        return
    end

    planListenerRegistered = true
    pm:RegisterListener("CompactUI_ListButton", function(event, _, _, count)
        if event ~= "plan_changed" and event ~= "plan_cleared" and event ~= "plan_loaded" then
            return
        end
        if planBtn and planBtn.label then
            local c = type(count) == "number" and count or (pm.GetCount and pm:GetCount()) or 0
            planBtn.label:SetText("Craft List (" .. tostring(c) .. ")")
            AutoSizeHeaderButton(planBtn)
        end
    end)
end

local function EnsureSettings()
    if not HousingDB then HousingDB = {} end
    if not HousingDB.settings then HousingDB.settings = {} end
    return HousingDB.settings
end

local function GetTheme()
    return _G.HousingTheme or {}
end

local function CreateHeaderButton(parent, text, width)
    local theme = GetTheme()
    local colors = theme.Colors or {}

    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width or 80, 26)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bg = colors.bgTertiary or { 0.16, 0.12, 0.24, 0.90 }
    local border = colors.borderPrimary or { 0.35, 0.30, 0.50, 0.8 }
    btn:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
    btn:SetBackdropBorderColor(border[1], border[2], border[3], border[4])

    local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("CENTER")
    label:SetText(text)
    local textPrimary = colors.textPrimary or { 0.92, 0.90, 0.96, 1.0 }
    label:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    btn.label = label

    local bgHover = colors.bgHover or { 0.22, 0.18, 0.32, 0.95 }
    local accent = colors.accentPrimary or { 0.80, 0.55, 0.95, 1.0 }
    local textHighlight = colors.textHighlight or { 0.98, 0.95, 1.0, 1.0 }
    btn:SetScript("OnEnter", function(selfBtn)
        selfBtn:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], bgHover[4])
        selfBtn:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
        if selfBtn.label then
            selfBtn.label:SetTextColor(textHighlight[1], textHighlight[2], textHighlight[3], 1)
        end
    end)
    btn:SetScript("OnLeave", function(selfBtn)
        selfBtn:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
        selfBtn:SetBackdropBorderColor(border[1], border[2], border[3], border[4])
        if selfBtn.label then
            selfBtn.label:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
        end
    end)

    if width == nil and label.GetStringWidth and btn.SetWidth then
        local w = tonumber(label:GetStringWidth()) or 0
        btn:SetWidth(math.max(44, w + 18))
        btn._hvAutoSized = true
    end

    return btn
end

local function AutoSizeHeaderButton(btn)
    if not (btn and btn._hvAutoSized and btn.label and btn.label.GetStringWidth and btn.SetWidth) then
        return
    end
    local w = tonumber(btn.label:GetStringWidth()) or 0
    btn:SetWidth(math.max(44, w + 18))
end

function CompactUI:OpenFullUI(callback)
    -- Track that we navigated into the Full UI from Compact UI so "Back" can return correctly.
    _G.HousingUIReturnTarget = "compact"
    isSwitchingToFullUI = true
    self:Hide()
    isSwitchingToFullUI = false
    if _G.HousingUINew and _G.HousingUINew.Show then
        _G.HousingUINew:Show()
    end
    if callback then
        pcall(callback)
    end
end

local function SetTooltip(owner, titleText, lines)
    if not (_G.GameTooltip and _G.GameTooltip.SetOwner and _G.GameTooltip.AddLine) then
        return
    end
    _G.GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    _G.GameTooltip:AddLine(titleText, 1, 1, 1)
    if type(lines) == "table" then
        for i = 1, #lines do
            _G.GameTooltip:AddLine(lines[i], 0.85, 0.85, 0.85, true)
        end
    end
    _G.GameTooltip:Show()
end

local function HideTooltip()
    if _G.GameTooltip and _G.GameTooltip.Hide then
        _G.GameTooltip:Hide()
    end
end

local function CreateSearchBox(parent, x, y, onChange, width)
    local theme = GetTheme()
    local colors = theme.Colors or {}

    local container = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    container:SetSize(width or 240, 24)
    container:SetPoint("TOPLEFT", x, y)
    container:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bg = colors.bgTertiary or { 0.16, 0.12, 0.24, 0.90 }
    local border = colors.borderPrimary or { 0.35, 0.30, 0.50, 0.8 }
    container:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
    container:SetBackdropBorderColor(border[1], border[2], border[3], border[4])

    local edit = CreateFrame("EditBox", nil, container)
    edit:SetPoint("TOPLEFT", 8, -4)
    edit:SetPoint("BOTTOMRIGHT", -8, 4)
    edit:SetAutoFocus(false)
    edit:SetFontObject("GameFontNormalSmall")
    local textPrimary = colors.textPrimary or { 0.92, 0.90, 0.96, 1.0 }
    edit:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    edit:SetScript("OnTextChanged", function(selfEdit)
        if onChange then
            onChange(selfEdit:GetText() or "")
        end
    end)
    edit:SetScript("OnEscapePressed", function(selfEdit) selfEdit:ClearFocus() end)

    return container, edit
end

local function GetCurrentZone()
    local mapID = (_G.C_Map and _G.C_Map.GetBestMapForUnit) and _G.C_Map.GetBestMapForUnit("player") or nil
    local zoneName = nil
    if mapID and _G.C_Map and _G.C_Map.GetMapInfo then
        local info = _G.C_Map.GetMapInfo(mapID)
        zoneName = info and info.name or nil
    end
    if (not zoneName or zoneName == "") and _G.GetZoneText then
        zoneName = _G.GetZoneText()
    end
    return mapID, zoneName
end

function CompactUI:ApplyAutoZoneFilter()
    if not frame then
        return
    end

    local settings = EnsureSettings()
    if not (settings and settings.autoFilterByZone == true) then
        return
    end

    local filters = frame._hvFilters
    if type(filters) ~= "table" then
        return
    end

    if filters._userSetZone == true then
        return
    end

    local mapID, zoneName = GetCurrentZone()
    if not (zoneName and zoneName ~= "") then
        return
    end

    filters.zone = zoneName
    filters.zoneMapID = mapID

    local ddZone = frame._hvZoneDropdown
    if ddZone and ddZone._hv and ddZone._hv.text and ddZone._hv.text.SetText then
        ddZone._hv.text:SetText(zoneName)
    end

    local itemList = frame._hvItemList
    if itemList and itemList.Filter then
        itemList:Filter(filters)
    end
end

function CompactUI:ApplyZoneFilter(zoneName, mapID)
    if not zoneName or zoneName == "" then
        return
    end

    if not frame then
        return
    end

    local filters = frame._hvFilters
    if type(filters) ~= "table" then
        return
    end

    filters.zone = zoneName
    filters.zoneMapID = mapID
    filters._userSetZone = false

    local ddZone = frame._hvZoneDropdown
    if ddZone and ddZone._hv and ddZone._hv.text and ddZone._hv.text.SetText then
        ddZone._hv.text:SetText(zoneName)
    end

    local itemList = frame._hvItemList
    if itemList and itemList.Filter then
        itemList:Filter(filters)
    end
end

function CompactUI:ApplyCollectionFilter(collectionValue)
    if not frame then
        return
    end

    local filters = frame._hvFilters
    if type(filters) ~= "table" then
        return
    end

    if collectionValue and collectionValue ~= "" then
        filters.collection = collectionValue
    end

    local itemList = frame._hvItemList
    if itemList and itemList.Filter then
        itemList:Filter(filters)
    end
end

local function CreateDropdown(parent, label, width, x, y, getOptions, onChange)
    local theme = GetTheme()
    local colors = theme.Colors or {}

    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(width, 30)
    container:SetPoint("TOPLEFT", x, y)

    local labelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    labelText:SetPoint("BOTTOMLEFT", container, "TOPLEFT", 2, 1)
    labelText:SetText(label .. ":")
    local accent = colors.accentPrimary or { 0.80, 0.55, 0.95, 1.0 }
    labelText:SetTextColor(accent[1], accent[2], accent[3], 1)

    local btn = CreateFrame("Button", nil, container, "BackdropTemplate")
    btn:SetSize(width, 24)
    btn:SetPoint("TOPLEFT", 0, 0)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bg = colors.bgTertiary or { 0.16, 0.12, 0.24, 0.90 }
    local border = colors.borderPrimary or { 0.35, 0.30, 0.50, 0.8 }
    btn:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
    btn:SetBackdropBorderColor(border[1], border[2], border[3], border[4])

    local textPrimary = colors.textPrimary or { 0.92, 0.90, 0.96, 1.0 }
    local buttonText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    buttonText:SetPoint("LEFT", 8, 0)
    buttonText:SetPoint("RIGHT", -20, 0)
    buttonText:SetJustifyH("LEFT")
    buttonText:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    btn.buttonText = buttonText

    local arrow = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    arrow:SetPoint("RIGHT", -6, 0)
    arrow:SetText("v")
    local textMuted = colors.textMuted or { 0.50, 0.48, 0.58, 1.0 }
    arrow:SetTextColor(textMuted[1], textMuted[2], textMuted[3], 1)

    local listFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    listFrame:SetSize(width + 80, 320)
    listFrame:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, -2)
    listFrame:SetFrameStrata("DIALOG")
    listFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bgPrimary = colors.bgPrimary or { 0.10, 0.07, 0.15, 0.98 }
    listFrame:SetBackdropColor(bgPrimary[1], bgPrimary[2], bgPrimary[3], 0.98)
    listFrame:SetBackdropBorderColor(accent[1], accent[2], accent[3], 0.8)
    listFrame:Hide()
    listFrame:EnableMouse(true)

    local scrollFrame = CreateFrame("ScrollFrame", nil, listFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(width, 1)
    scrollFrame:SetScrollChild(content)

    local optionButtons = {}
    local function Populate()
        for _, b in ipairs(optionButtons) do
            b:Hide()
            b:SetParent(nil)
        end
        wipe(optionButtons)

        local options = {}
        if getOptions then
            options = getOptions() or {}
        end
        local yOff = 0
        for _, opt in ipairs(options) do
            local b = CreateFrame("Button", nil, content)
            b:SetSize(width + 40, 24)
            b:SetPoint("TOPLEFT", 0, yOff)
            local t = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            t:SetPoint("LEFT", 6, 0)
            t:SetText(opt)
            t:SetJustifyH("LEFT")
            t:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
            b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
            b:SetScript("OnClick", function()
                listFrame:Hide()
                buttonText:SetText(opt)
                if onChange then onChange(opt) end
            end)
            optionButtons[#optionButtons + 1] = b
            yOff = yOff - 24
        end
        content:SetHeight(math.max(1, #options * 24))
    end

    btn:SetScript("OnClick", function()
        if listFrame:IsShown() then
            listFrame:Hide()
            return
        end
        Populate()
        listFrame:Show()
    end)

    container._hv = { button = btn, text = buttonText, listFrame = listFrame }
    return container
end

function CompactUI:Create()
    if frame then
        return frame
    end

    local theme = GetTheme()
    local colors = theme.Colors or {}
    local dims = theme.Dimensions or {}

    frame = CreateFrame("Frame", "HousingCompactFrame", UIParent, "BackdropTemplate")
    frame:SetSize(dims.compactFrameWidth or 600, dims.mainFrameHeight or 700)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("HIGH")
    frame:Hide()
    table.insert(UISpecialFrames, "HousingCompactFrame")

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 2,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bgPrimary = colors.bgPrimary or { 0.10, 0.07, 0.15, 0.98 }
    local borderPrimary = colors.borderPrimary or { 0.35, 0.30, 0.50, 0.8 }
    frame:SetBackdropColor(bgPrimary[1], bgPrimary[2], bgPrimary[3], bgPrimary[4] or 1)
    frame:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4] or 1)

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local header = CreateFrame("Frame", nil, frame)
    header:SetPoint("TOPLEFT", 2, -2)
    header:SetPoint("TOPRIGHT", -2, -2)
    header:SetHeight(52)

    local headerBg = header:CreateTexture(nil, "BACKGROUND")
    headerBg:SetTexture("Interface\\Buttons\\WHITE8x8")
    headerBg:SetAllPoints()
    headerBg:SetGradient("HORIZONTAL", CreateColor(0.12, 0.35, 0.65, 0.95), CreateColor(0.08, 0.25, 0.50, 0.95))

    local title = header:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("LEFT", 14, 2)
    title:SetText(L["HOUSING_VENDOR_TITLE_COMPACT"] or "Housing Decor")
    local textPrimary = colors.textPrimary or { 0.92, 0.90, 0.96, 1.0 }
    title:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)

    local buttons = CreateFrame("Frame", nil, header)
    buttons:SetPoint("RIGHT", -50, 0)
    buttons:SetHeight(30)
    title:SetPoint("RIGHT", buttons, "LEFT", -10, 0)

    local btnFull = CreateHeaderButton(buttons, "Full UI")
    btnFull:SetPoint("RIGHT", 0, 0)
    btnFull:SetScript("OnClick", function()
        CompactUI:OpenFullUI()
    end)
    if btnFull and btnFull.HookScript then
        btnFull:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Full UI", {
                "Opens the full interface with all panels and options.",
                "Tip: use Back to return here.",
            })
        end)
        btnFull:HookScript("OnLeave", HideTooltip)
    end

    local btnSettings = CreateHeaderButton(buttons, L["BUTTON_SETTINGS"] or "Settings")
    btnSettings:SetPoint("RIGHT", btnFull, "LEFT", -10, 0)
    btnSettings:SetScript("OnClick", function()
        if _G.HousingConfigUI then
            _G.HousingConfigUI:Show()
        end
    end)
    if btnSettings and btnSettings.HookScript then
        btnSettings:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Settings", {
                "Configure Compact Mode, Zone Popups, and auto-filter options.",
                "Most settings apply to both Compact UI and Full UI.",
            })
        end)
        btnSettings:HookScript("OnLeave", HideTooltip)
    end

    local btnZone = CreateHeaderButton(buttons, "Zone Popup")
    btnZone:SetPoint("RIGHT", btnSettings, "LEFT", -10, 0)
    btnZone:SetScript("OnClick", function()
        if _G.HousingOutstandingItemsUI and _G.HousingOutstandingItemsUI.TogglePopup then
            _G.HousingOutstandingItemsUI:TogglePopup()
        end
    end)
    if btnZone and btnZone.HookScript then
        btnZone:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Zone Popup", {
                "Shows a small window for your current zone.",
                "Highlights uncollected decor and where it comes from (vendors/quests/achievements/drops).",
            })
        end)
        btnZone:HookScript("OnLeave", HideTooltip)
    end

    -- Size the header button container to its contents so the title can clamp correctly.
    if buttons and buttons.SetWidth and btnFull and btnSettings and btnZone and btnFull.GetWidth and btnSettings.GetWidth and btnZone.GetWidth then
        local total = (btnFull:GetWidth() or 0) + (btnSettings:GetWidth() or 0) + (btnZone:GetWidth() or 0) + (2 * 10)
        buttons:SetWidth(math.max(1, total))
    end

    -- Nav bar (separate row): Ach/Rep/Stats/AH + Mats.
    navBar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    navBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -55)
    navBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -55)
    navBar:SetHeight(34)
    navBar:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bgSecondary = colors.bgSecondary or { 0.12, 0.10, 0.20, 0.95 }
    navBar:SetBackdropColor(bgSecondary[1], bgSecondary[2], bgSecondary[3], bgSecondary[4])
    navBar:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], 0.5)

    local function CreateNav(label, width, onClick)
        local b = CreateHeaderButton(navBar, label, width)
        b:SetScript("OnClick", onClick)
        return b
    end

    local navGap = 6

    local btnAH = CreateNav(L["AUCTION_HOUSE_TITLE"] or "Auction House", nil, function()
        CompactUI:OpenFullUI(function()
            if _G.HousingAuctionHouseUI and _G.HousingAuctionHouseUI.Show then
                _G.HousingAuctionHouseUI:Show()
            end
        end)
    end)
    btnAH:SetPoint("RIGHT", navBar, "RIGHT", -10, 0)
    if btnAH and btnAH.HookScript then
        btnAH:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Auction House", {
                "Shows Auction House prices for crafting materials.",
                "Use this to estimate total craft costs and compare prices.",
            })
        end)
        btnAH:HookScript("OnLeave", HideTooltip)
    end

    local btnStats = CreateNav("Statistics", nil, function()
        CompactUI:OpenFullUI(function()
            if _G.HousingStatisticsUI and _G.HousingStatisticsUI.Show then
                _G.HousingStatisticsUI:Show()
            end
        end)
    end)
    btnStats:SetPoint("RIGHT", btnAH, "LEFT", -navGap, 0)
    if btnStats and btnStats.HookScript then
        btnStats:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Statistics", {
                "Shows collection progress and breakdowns.",
                "Helpful for tracking what you're missing overall.",
            })
        end)
        btnStats:HookScript("OnLeave", HideTooltip)
    end

    local btnRep = CreateNav("Reputation", nil, function()
        CompactUI:OpenFullUI(function()
            if _G.HousingReputationUI and _G.HousingReputationUI.Show then
                _G.HousingReputationUI:Show()
            end
        end)
    end)
    btnRep:SetPoint("RIGHT", btnStats, "LEFT", -navGap, 0)
    if btnRep and btnRep.HookScript then
        btnRep:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Reputation", {
                "Shows reputation requirements for decor items.",
                "Useful for planning which reputations to work on.",
            })
        end)
        btnRep:HookScript("OnLeave", HideTooltip)
    end

    local btnAch = CreateNav("Achievements", nil, function()
        CompactUI:OpenFullUI(function()
            if _G.HousingAchievementsUI and _G.HousingAchievementsUI.Show then
                _G.HousingAchievementsUI:Show()
            end
        end)
    end)
    btnAch:SetPoint("RIGHT", btnRep, "LEFT", -navGap, 0)
    if btnAch and btnAch.HookScript then
        btnAch:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Achievements", {
                "Shows achievement-based decor and progress tracking.",
                "Click an achievement item to view details.",
            })
        end)
        btnAch:HookScript("OnLeave", HideTooltip)
    end

    planBtn = CreateNav("Craft List (0)", nil, function()
        if _G.HousingPlanUI and _G.HousingPlanUI.Toggle then
            _G.HousingPlanUI:Toggle()
        end
    end)
    planBtn:SetPoint("RIGHT", btnAch, "LEFT", -navGap, 0)
    EnsureListButtonListener()
    if planBtn and planBtn.HookScript then
        planBtn:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Crafting List", {
                "Track decor you plan to craft.",
                "Shows combined reagents, owned vs missing, and cost estimates.",
            })
        end)
        planBtn:HookScript("OnLeave", HideTooltip)
    end

    local closeBtn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", -8, -8)
    closeBtn:SetBackdrop(btnFull:GetBackdrop())
    closeBtn:SetBackdropColor(colors.bgTertiary[1], colors.bgTertiary[2], colors.bgTertiary[3], colors.bgTertiary[4])
    closeBtn:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], borderPrimary[4])
    local closeText = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    closeText:SetPoint("CENTER", 0, 1)
    closeText:SetText("X")
    closeText:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)
    if closeBtn and closeBtn.HookScript then
        closeBtn:HookScript("OnEnter", function(selfBtn)
            SetTooltip(selfBtn, "Close", {
                "Closes this window.",
                "Tip: the minimap button (or /hv) can reopen it.",
            })
        end)
        closeBtn:HookScript("OnLeave", HideTooltip)
    end

    -- Filter bar
    local filter = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    -- Slight gap under the nav bar.
    filter:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -95)
    filter:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -95)
    filter:SetHeight(78)
    filter:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    filter:SetBackdropColor(bgSecondary[1], bgSecondary[2], bgSecondary[3], bgSecondary[4])
    filter:SetBackdropBorderColor(borderPrimary[1], borderPrimary[2], borderPrimary[3], 0.5)

    local FilterModel = ns.FilterModel
    local currentFilters = (FilterModel and FilterModel.CreateDefaultFilters and FilterModel:CreateDefaultFilters()) or {
        searchText = "",
        expansion = "All Expansions",
        source = "All Sources",
        zone = "All Zones",
        vendor = "All Vendors",
        type = "All Types",
        category = "All Categories",
        faction = "All Factions",
        collection = "All",
        quality = "All Qualities",
        requirement = "All Requirements",
        hideVisited = false,
        hideNotReleased = false,
        showOnlyAvailable = true,
        selectedExpansions = {},
        selectedSources = {},
        selectedFactions = {},
        excludeExpansions = false,
        excludeSources = false,
        zoneMapID = nil,
        _userSetZone = false,
    }
    frame._hvFilters = currentFilters

    local function Refresh()
        if list and list.Filter then
            list:Filter(currentFilters)
        end
    end

    local _, searchEdit = CreateSearchBox(filter, 15, -16, function(text)
        currentFilters.searchText = text
        Refresh()
    end, 160)
    frame._hvSearchEdit = searchEdit

    local function GetFilterOptions(key, allLabel)
        local opts = {}
        opts[1] = allLabel
        local dm = _G.HousingDataManager
        if dm and dm.GetFilterOptions then
            local fo = dm:GetFilterOptions()
            local list = fo and fo[key] or nil
            if type(list) == "table" then
                for i = 1, #list do
                    opts[#opts + 1] = list[i]
                end
            end
        end
        return opts
    end

    local ddExpansion = CreateDropdown(filter, "Expansion", 140, 183, -16, function()
        return GetFilterOptions("expansions", "All Expansions")
    end, function(v)
        currentFilters.expansion = v
        currentFilters.selectedExpansions = {}
        Refresh()
    end)
    ddExpansion._hv.text:SetText("All Expansions")

    local ddSource = CreateDropdown(filter, "Source", 130, 331, -16, function()
        return GetFilterOptions("sources", "All Sources")
    end, function(v)
        currentFilters.source = v
        currentFilters.selectedSources = {}
        Refresh()
    end)
    ddSource._hv.text:SetText("All Sources")

    local ddZone = CreateDropdown(filter, "Zone", 110, 469, -16, function()
        return GetFilterOptions("zones", "All Zones")
    end, function(v)
        currentFilters.zone = v
        currentFilters.zoneMapID = nil
        currentFilters._userSetZone = v ~= "All Zones"
        Refresh()
    end)
    ddZone._hv.text:SetText("All Zones")
    frame._hvZoneDropdown = ddZone

    local clearBtn = CreateHeaderButton(filter, L["FILTER_CLEAR_SHORT"] or "Clear", 60)
    clearBtn:SetPoint("TOPRIGHT", -10, -46)
    clearBtn:SetScript("OnClick", function()
        if FilterModel and FilterModel.ResetToDefaults then
            FilterModel:ResetToDefaults(currentFilters)
        else
            currentFilters.searchText = ""
            currentFilters.expansion = "All Expansions"
            currentFilters.source = "All Sources"
            currentFilters.zone = "All Zones"
            currentFilters.zoneMapID = nil
            currentFilters._userSetZone = false
        end
        if frame and frame._hvSearchEdit and frame._hvSearchEdit.SetText then
            frame._hvSearchEdit:SetText("")
        end
        ddExpansion._hv.text:SetText("All Expansions")
        ddSource._hv.text:SetText("All Sources")
        ddZone._hv.text:SetText("All Zones")
        Refresh()
    end)

    local listModule = ns.SimpleItemList or _G.HousingSimpleItemList
    list = setmetatable({}, listModule)
    list:Create(frame)
    list:SetAnchors(-180, 52)
    frame._hvItemList = list

    frame:HookScript("OnShow", function()
        -- Ensure deferred data aggregation runs so vendor pool/indices (coords) are available.
        if _G.HousingDataAggregator and _G.HousingDataAggregator.ProcessPendingData then
            pcall(_G.HousingDataAggregator.ProcessPendingData, _G.HousingDataAggregator)
        end

        -- Ensure data is available.
        if _G.HousingDataLoader and _G.HousingDataLoader.LoadData then
            _G.HousingDataLoader:LoadData()
        end

        if _G.HousingDataManager and _G.HousingDataManager.GetAllItemIDs then
            local allIDs = _G.HousingDataManager:GetAllItemIDs()
            list:SetItems(allIDs)
            CompactUI:ApplyAutoZoneFilter()
            list:Filter(currentFilters)
        end

        local pm = _G.HousingPlanManager
        if planBtn and planBtn.label and pm and pm.GetCount then
            planBtn.label:SetText("Craft List (" .. tostring(pm:GetCount() or 0) .. ")")
        end

        -- Start background handlers only while a UI is open (reduces idle CPU).
        if _G.HousingDataManager and _G.HousingDataManager.SetUIActive then
            _G.HousingDataManager:SetUIActive(true)
        end
        if _G.HousingCollectionAPI and _G.HousingCollectionAPI.StartEventHandlers then
            _G.HousingCollectionAPI:StartEventHandlers()
        end
        if _G.HousingReputation and _G.HousingReputation.StartTracking then
            _G.HousingReputation:StartTracking()
        end
        if _G.HousingDataEnhancer and _G.HousingDataEnhancer.StartMarketRefresh then
            _G.HousingDataEnhancer:StartMarketRefresh()
        end
        if _G.HousingAPICache and _G.HousingAPICache.StartCleanupTimer then
            _G.HousingAPICache:StartCleanupTimer()
        end
    end)

    frame:HookScript("OnHide", function()
        -- Don't tear down handlers if we're navigating into the Full UI.
        if isSwitchingToFullUI then
            return
        end

        -- Stop background handlers to eliminate idle CPU when the addon UI is closed.
        if _G.HousingDataManager and _G.HousingDataManager.SetUIActive then
            _G.HousingDataManager:SetUIActive(false)
        end
        if _G.HousingDataManager and _G.HousingDataManager.CancelBatchLoads then
            _G.HousingDataManager:CancelBatchLoads()
        end
        if _G.HousingAPICache and _G.HousingAPICache.StopCleanupTimer then
            _G.HousingAPICache:StopCleanupTimer()
        end
        if _G.HousingCollectionAPI and _G.HousingCollectionAPI.StopEventHandlers then
            _G.HousingCollectionAPI:StopEventHandlers()
        end
        if _G.HousingReputation and _G.HousingReputation.StopTracking then
            _G.HousingReputation:StopTracking()
        end
        if _G.HousingDataEnhancer and _G.HousingDataEnhancer.StopMarketRefresh then
            _G.HousingDataEnhancer:StopMarketRefresh()
        end
        if _G.HousingWaypointManager and _G.HousingWaypointManager.ClearWaypoint then
            _G.HousingWaypointManager:ClearWaypoint()
        end
    end)

    return frame
end

function CompactUI:Show()
    self:Create()

    -- Initialize core pieces if needed (DataManager/Icons).
    if _G.HousingUINew and _G.HousingUINew.Initialize then
        pcall(function() _G.HousingUINew:Initialize() end)
    end

    frame:Show()
end

function CompactUI:Hide()
    if frame then frame:Hide() end
end

function CompactUI:Toggle()
    self:Create()
    if frame:IsShown() then
        frame:Hide()
    else
        self:Show()
    end
end

function CompactUI:OpenFullDetailsForItem(item)
    -- Mark that the Full UI was opened from Compact UI so Back/return actions can bring us here.
    _G.HousingUIReturnTarget = "compact"
    isSwitchingToFullUI = true
    self:Hide()
    isSwitchingToFullUI = false
    if _G.HousingUINew and _G.HousingUINew.Show then
        _G.HousingUINew:Show()
    end

    -- Also align the main item list in Full UI to the same itemID (so list + info panel stay in sync).
    do
        local itemID = item and tonumber(item.itemID) or nil
        if itemID and _G.C_Timer and _G.C_Timer.After then
            local attemptsLeft = 20
            local function TryAlignList()
                attemptsLeft = attemptsLeft - 1
                local list = _G.HousingItemList
                if list and list.ScrollToItemID and list:ScrollToItemID(itemID) then
                    return
                end
                if attemptsLeft > 0 then
                    _G.C_Timer.After(0, TryAlignList)
                end
            end
            TryAlignList()
        end
    end

    -- Preview panel may not be initialized yet on the very first transition (Compact can call
    -- HousingUINew:Initialize without building sub-panels). Retry briefly so a single click always works.
    if _G.HousingPreviewPanel and _G.HousingPreviewPanel.ShowItem and _G.C_Timer and _G.C_Timer.After then
        local attemptsLeft = 10
        local function TryShow()
            attemptsLeft = attemptsLeft - 1
            local panel = _G.HousingPreviewPanel
            local frame = panel and panel.GetFrame and panel:GetFrame() or nil
            if frame then
                pcall(function() panel:ShowItem(item) end)
                return
            end
            if attemptsLeft > 0 then
                _G.C_Timer.After(0, TryShow)
            end
        end
        TryShow()
    end
end

function CompactUI:SetShowOnlyAvailable(showOnlyAvailable)
    self:Create()
    if frame and frame._hvFilters then
        frame._hvFilters.showOnlyAvailable = (showOnlyAvailable == true)
    end
    local itemList = frame and frame._hvItemList or nil
    if itemList and itemList.Filter and frame and frame._hvFilters then
        itemList:Filter(frame._hvFilters)
    end
end

ns.CompactUI = CompactUI
_G.HousingCompactUI = CompactUI

-- Backwards-compat: previous name used by older builds/macros.
ns.SimpleUI = CompactUI
_G.HousingSimpleUI = CompactUI

return CompactUI
