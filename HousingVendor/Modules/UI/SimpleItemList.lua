-- SimpleItemList.lua
-- Separate item list instance for the standalone Compact UI frame (does not share globals with the main UI).

local ADDON_NAME, ns = ...

local SimpleItemList = {}
SimpleItemList.__index = SimpleItemList

local BUTTON_HEIGHT = 48
local BUTTON_SPACING = 4
local VISIBLE_BUTTONS = 12
local ACTION_BAR_HEIGHT = 26

local function GetTheme()
    return _G.HousingTheme or {}
end

local function GetItemIconByID(itemID)
    local id = tonumber(itemID)
    if not id then return nil end
    if _G.C_Item and _G.C_Item.GetItemIconByID then
        return _G.C_Item.GetItemIconByID(id)
    end
    if _G.GetItemIcon then
        return _G.GetItemIcon(id)
    end
    return nil
end

local function RequestItemDataByID(itemID)
    local id = tonumber(itemID)
    if not id then return end
    if _G.C_Item and _G.C_Item.RequestLoadItemDataByID then
        _G.C_Item.RequestLoadItemDataByID(id)
    end
end

local function CancelHandle(handle)
    if handle and handle.Cancel then
        handle:Cancel()
    end
end

local function GetItemRecordName(itemID)
    local dm = _G.HousingDataManager
    if dm and dm.GetItemRecord then
        local rec = dm:GetItemRecord(tonumber(itemID))
        if rec and rec.name and rec.name ~= "" and rec.name ~= "Unknown Item" then
            return rec.name
        end
    end
    return nil
end

local function GetItemTooltipLink(itemID)
    local id = tonumber(itemID)
    if not id then return nil end
    if _G.C_Item and _G.C_Item.GetItemLink then
        local ok, link = pcall(_G.C_Item.GetItemLink, id)
        if ok and link and link ~= "" then
            return link
        end
    end
    if _G.GetItemInfo then
        local link = select(2, _G.GetItemInfo(id))
        if link and link ~= "" then
            return link
        end
    end
    return nil
end

local function ShowItemTooltip(owner, itemID)
    if not (_G.GameTooltip and _G.GameTooltip.SetOwner) then
        return
    end
    local id = tonumber(itemID)
    if not id then return end

    _G.GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
    local link = GetItemTooltipLink(id)
    if link and _G.GameTooltip.SetHyperlink then
        _G.GameTooltip:SetHyperlink(link)
    elseif _G.GameTooltip.SetItemByID then
        _G.GameTooltip:SetItemByID(id)
    end
    _G.GameTooltip:AddLine(" ")
    _G.GameTooltip:AddLine("Click for more details", 0.85, 0.85, 0.85)
    _G.GameTooltip:Show()
end

local function GetItemNameByID(itemID)
    local id = tonumber(itemID)
    if not id then return nil end
    if _G.C_Item and _G.C_Item.GetItemNameByID then
        local name = _G.C_Item.GetItemNameByID(id)
        if name and name ~= "" then
            return name
        end
    end
    if _G.GetItemInfo then
        local name = _G.GetItemInfo(id)
        if name and name ~= "" then
            return name
        end
    end
    return nil
end

local QUALITY_COLOR_BY_ID = {
    [0] = "|cff9d9d9d", -- Poor
    [1] = "|cffEBE8F0", -- Common
    [2] = "|cff1EFF00", -- Uncommon
    [3] = "|cff4080E6", -- Rare
    [4] = "|cffA855F7", -- Epic
    [5] = "|cffFF8000", -- Legendary
}

local function GetQualityColorCode(quality)
    if quality == nil then return nil end
    if type(quality) == "number" then
        return QUALITY_COLOR_BY_ID[quality]
    end
    return nil
end

local function GetItemQualityByID(itemID)
    local id = tonumber(itemID)
    if not id then return nil end
    if _G.C_Item and _G.C_Item.GetItemQualityByID then
        local q = _G.C_Item.GetItemQualityByID(id)
        if q ~= nil then
            return q
        end
    end
    if _G.GetItemInfo then
        local _, _, q = _G.GetItemInfo(id)
        return q
    end
    return nil
end

local function FormatMoneyFromCopper(copper)
    local amount = tonumber(copper) or 0
    if _G.GetCoinTextureString then
        return _G.GetCoinTextureString(amount)
    end
    local gold = math.floor(amount / 10000)
    local silver = math.floor((amount % 10000) / 100)
    local c = amount % 100
    return string.format("%dg %02ds %02dc", gold, silver, c)
end

local function IsProfessionItem(item, itemID)
    if item and item.profession and item.profession ~= "" then
        return true
    end
    local prof = _G.HousingProfessionData
    if type(prof) == "table" and itemID and prof[itemID] then
        return true
    end
    return false
end

local function GetBestVendorContext(item, filters)
    filters = type(filters) == "table" and filters or {}
    local filterVendor = filters.vendor
    local filterZone = filters.zone
    local filterMapID = filters.zoneMapID

    local vendorName = nil
    local zoneName = nil
    local coords = nil

    if _G.HousingVendorHelper then
        vendorName = _G.HousingVendorHelper:GetVendorName(item, filterVendor, filterZone, filterMapID)
        zoneName = _G.HousingVendorHelper:GetZoneName(item, filterZone, filterMapID)
        coords = _G.HousingVendorHelper:GetVendorCoords(item, filterVendor, filterZone, filterMapID)
    else
        vendorName = item and (item.vendorName or item._apiVendor) or nil
        zoneName = item and (item._apiZone or item.zoneName) or nil
        coords = item and (item.coords or item.vendorCoords) or nil
    end

    return vendorName, zoneName, coords
end

local function GetBestWaypointContext(item, itemID, filters, isProfessionItem)
    if isProfessionItem and itemID then
        local hv = _G.HousingVendor
        local pt = hv and hv.ProfessionTrainers
        if pt and pt.GetTrainerForItem then
            local trainer = pt:GetTrainerForItem(itemID, item)
            local coords = trainer and trainer.coords or nil
            local x = coords and tonumber(coords.x) or nil
            local y = coords and tonumber(coords.y) or nil
            local mapID = coords and tonumber(coords.mapID) or nil
            if x and y and mapID and x > 0 and y > 0 and mapID > 0 then
                return (trainer and trainer.name) or "Trainer", (trainer and trainer.location) or nil, coords, "trainer"
            end
        end
    end

    local vendorName, zoneName, coords = GetBestVendorContext(item, filters)
    return vendorName, zoneName, coords, "vendor"
end

local function SetActionShown(btn, shown)
    if not btn then return end
    if btn.SetShown then
        btn:SetShown(shown == true)
    else
        if shown == true and btn.Show then
            btn:Show()
        elseif shown ~= true and btn.Hide then
            btn:Hide()
        end
    end
end

local function LayoutActionBar(button)
    if not (button and button.actionBar) then return end
    local bar = button.actionBar
    local order = { button.btnPlan, button.btnWaypoint, button.btnMark, button.btnMats }
    local spacing = 6
    local prev = nil
    local totalWidth = 0
    for i = 1, #order do
        local b = order[i]
        if b and b.IsShown and b:IsShown() then
            b:ClearAllPoints()
            if prev then
                b:SetPoint("LEFT", prev, "RIGHT", spacing, 0)
                totalWidth = totalWidth + spacing
            else
                b:SetPoint("LEFT", bar, "LEFT", 0, 0)
            end
            totalWidth = totalWidth + (b.GetWidth and b:GetWidth() or 0)
            prev = b
        end
    end
    if totalWidth < 1 then totalWidth = 1 end
    if bar.SetWidth then
        bar:SetWidth(totalWidth)
    end
end

local function CreateIconButton(parent, iconTexture, width)
    local theme = GetTheme()
    local colors = theme.Colors or {}

    local btn = _G.CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(width, ACTION_BAR_HEIGHT)
    if btn.SetHitRectInsets then
        btn:SetHitRectInsets(-6, -6, -6, -6)
    end
    if parent and parent.GetFrameLevel and btn.SetFrameLevel then
        btn:SetFrameLevel((parent:GetFrameLevel() or 0) + 3)
    end
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

    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("CENTER")
    icon:SetSize(16, 16)
    icon:SetTexture(iconTexture)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    btn.icon = icon

    local bgHover = colors.bgHover or { 0.22, 0.18, 0.32, 0.95 }
    local accent = colors.accentPrimary or { 0.80, 0.55, 0.95, 1.0 }
    local textHighlight = colors.textHighlight or { 0.98, 0.95, 1.0, 1.0 }
    btn:SetScript("OnEnter", function(selfBtn)
        selfBtn:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], bgHover[4])
        selfBtn:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
        if selfBtn.icon then
            selfBtn.icon:SetVertexColor(textHighlight[1], textHighlight[2], textHighlight[3], 1)
        end
        if selfBtn.tooltipText then
            _G.GameTooltip:SetOwner(selfBtn, "ANCHOR_TOP")
            _G.GameTooltip:SetText(selfBtn.tooltipText, 1, 1, 1, 1, true)
            _G.GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function(selfBtn)
        selfBtn:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
        selfBtn:SetBackdropBorderColor(border[1], border[2], border[3], border[4])
        if selfBtn.icon then
            selfBtn.icon:SetVertexColor(1, 1, 1, 1)
        end
        if _G.GameTooltip and _G.GameTooltip.IsOwned and _G.GameTooltip:IsOwned(selfBtn) then
            _G.GameTooltip:Hide()
        end
        local row = selfBtn and selfBtn:GetParent() and selfBtn:GetParent():GetParent()
        if row and row._hvShowItemTooltip and _G.MouseIsOver and _G.MouseIsOver(row) then
            row:_hvShowItemTooltip()
        end
    end)

    return btn
end

function SimpleItemList:Create(parentFrame)
    self.parentFrame = parentFrame
    self._hvNameRefreshPending = {}
    self._hvQualityRefreshPending = {}
    self._hvNameCache = {}
    -- Compact list intentionally does not render costs/currencies or AH prices.

    self.scrollFrame = _G.CreateFrame("ScrollFrame", "HousingSimpleItemListScrollFrame", parentFrame, "UIPanelScrollFrameTemplate")
    self.scrollFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 20, -140)
    self.scrollFrame:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -20, 52)

    self.container = _G.CreateFrame("Frame", "HousingSimpleItemListContainer", self.scrollFrame)
    self.container:SetWidth(self.scrollFrame:GetWidth() - 20)
    self.container:SetHeight(100)
    self.scrollFrame:SetScrollChild(self.container)

    self.buttons = {}
    self.items = {}
    self.filteredItems = {}

    self.scrollFrame:SetScript("OnVerticalScroll", function(sf, offset)
        _G.ScrollFrame_OnVerticalScroll(sf, offset, BUTTON_HEIGHT + BUTTON_SPACING)
        self:UpdateVisible()
    end)

    self:UpdateVisible()
end

function SimpleItemList:SetAnchors(topOffset, bottomOffset)
    if not self.scrollFrame then return end
    self.scrollFrame:ClearAllPoints()
    self.scrollFrame:SetPoint("TOPLEFT", self.parentFrame, "TOPLEFT", 20, topOffset)
    self.scrollFrame:SetPoint("BOTTOMRIGHT", self.parentFrame, "BOTTOMRIGHT", -20, bottomOffset)
    if self.container and self.container.SetWidth then
        self.container:SetWidth(math.max(1, self.scrollFrame:GetWidth() - 20))
    end
    self:UpdateVisible()
end

function SimpleItemList:SetItems(items)
    self.items = items or {}
    self.filteredItems = self.items
    if self.container then
        local totalHeight = math.max(100, #self.filteredItems * (BUTTON_HEIGHT + BUTTON_SPACING) + 10)
        self.container:SetHeight(totalHeight)
    end
    if self.scrollFrame then
        self.scrollFrame:UpdateScrollChildRect()
        self.scrollFrame:SetVerticalScroll(0)
    end
    self:UpdateVisible()
end

function SimpleItemList:Filter(filters)
    self._hvFilters = filters or {}
    local dm = _G.HousingDataManager
    if not dm then
        self.filteredItems = self.items
        self:UpdateVisible()
        return
    end
    if dm.FilterItemIDs then
        self.filteredItems = dm:FilterItemIDs(self.items, filters or {})
    elseif dm.FilterItems then
        local full = {}
        for i = 1, #self.items do
            local id = tonumber(self.items[i])
            if id and dm.GetItemRecord then
                local r = dm:GetItemRecord(id)
                if r then
                    table.insert(full, r)
                end
            end
        end
        self.filteredItems = dm:FilterItems(full, filters or {})
    else
        self.filteredItems = self.items
    end

    if self.container then
        local totalHeight = math.max(100, #self.filteredItems * (BUTTON_HEIGHT + BUTTON_SPACING) + 10)
        self.container:SetHeight(totalHeight)
    end
    if self.scrollFrame then
        self.scrollFrame:UpdateScrollChildRect()
        self.scrollFrame:SetVerticalScroll(0)
    end
    self:UpdateVisible()
end

function SimpleItemList:CreateButton(index)
    local theme = GetTheme()
    local colors = theme.Colors or {}

    local button = _G.CreateFrame("Button", "HousingSimpleItemButton" .. index, self.container, "BackdropTemplate")
    button:SetHeight(BUTTON_HEIGHT)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    local bg = colors.bgTertiary or { 0.16, 0.12, 0.24, 0.90 }
    local border = colors.borderPrimary or { 0.35, 0.30, 0.50, 0.8 }
    button:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
    button:SetBackdropBorderColor(border[1], border[2], border[3], border[4])
    button._hvRowBg = bg
    button._hvRowBorder = border

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(38, 38)
    icon:SetPoint("LEFT", 12, 0)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    button.icon = icon

    local nameText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("LEFT", icon, "RIGHT", 12, 4)
    nameText:SetWidth(220)
    nameText:SetJustifyH("LEFT")
    local textPrimary = colors.textPrimary or { 0.92, 0.90, 0.96, 1.0 }
    nameText:SetTextColor(textPrimary[1], textPrimary[2], textPrimary[3], 1)
    button.nameText = nameText

    local vendorText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    vendorText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
    vendorText:SetWidth(140)
    vendorText:SetJustifyH("LEFT")
    local textSecondary = colors.textSecondary or { 0.70, 0.68, 0.78, 1.0 }
    vendorText:SetTextColor(textSecondary[1], textSecondary[2], textSecondary[3], 1)
    button.vendorText = vendorText

    local recipeText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    recipeText:SetPoint("LEFT", vendorText, "RIGHT", 8, 0)
    recipeText:SetWidth(90)
    recipeText:SetJustifyH("LEFT")
    recipeText:SetTextColor(textSecondary[1], textSecondary[2], textSecondary[3], 1)
    recipeText:SetText("")
    recipeText:Hide()
    button.recipeText = recipeText

    local zoneText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    zoneText:SetJustifyH("RIGHT")
    local textMuted = colors.textMuted or { 0.50, 0.48, 0.58, 1.0 }
    zoneText:SetTextColor(textMuted[1], textMuted[2], textMuted[3], 1)
    button.zoneText = zoneText

    local actionBar = _G.CreateFrame("Frame", nil, button)
    actionBar:SetPoint("RIGHT", button, "RIGHT", -10, 0)
    actionBar:SetHeight(ACTION_BAR_HEIGHT)
    if actionBar.SetFrameLevel and button.GetFrameLevel then
        actionBar:SetFrameLevel((button:GetFrameLevel() or 0) + 2)
    end
    button.actionBar = actionBar

    button.btnPlan = CreateIconButton(actionBar, "Interface\\Buttons\\UI-PlusButton-Up", 26)
    button.btnPlan.tooltipText = "Add to Crafting List\nTracks this decor as something you plan to craft.\nOpen Craft List to see combined materials and costs."

    -- Match the Full UI preview panel "Set Waypoint" icon.
    button.btnWaypoint = CreateIconButton(actionBar, "Interface\\Icons\\INV_Misc_Map_01", 26)
    button.btnWaypoint.tooltipText = "Set Waypoint\nSets a waypoint to the best source currently shown (vendor or trainer)."

    button.btnMark = CreateIconButton(actionBar, "Interface\\AddOns\\HousingVendor\\Data\\Media\\target_icon_blizzard_32.tga", 26)
    if button.btnMark and button.btnMark.icon then
        button.btnMark.icon:SetTexCoord(0, 1, 0, 1)
    end
    button.btnMark.tooltipText = "Show Vendor Marker\nHighlights the vendor on your screen (when available)."

    button.btnMats = CreateIconButton(actionBar, "Interface\\Icons\\INV_Misc_Bag_10", 26)
    button.btnMats.tooltipText = "Track Materials\nAdds/removes this item's crafting reagents in the materials tracker."

    button.btnPlan:SetPoint("LEFT", actionBar, "LEFT", 0, 0)
    button.btnWaypoint:SetPoint("LEFT", button.btnPlan, "RIGHT", 6, 0)
    button.btnMark:SetPoint("LEFT", button.btnWaypoint, "RIGHT", 6, 0)
    button.btnMats:SetPoint("LEFT", button.btnMark, "RIGHT", 6, 0)

    zoneText:SetPoint("RIGHT", actionBar, "LEFT", -12, 0)

    button:EnableMouse(true)
    button:RegisterForClicks("AnyUp")
    button:SetScript("OnClick", function(_, mouseButton)
        if mouseButton ~= "LeftButton" then
            return
        end
        local item = button._hvItem
        if not item then return end
        local compact = _G.HousingCompactUI or _G.HousingSimpleUI
        if compact and compact.OpenFullDetailsForItem then
            compact:OpenFullDetailsForItem(item)
        end
    end)

    local bgHover = colors.bgHover or { 0.22, 0.18, 0.32, 0.95 }
    local accent = colors.accentPrimary or { 0.80, 0.55, 0.95, 1.0 }

    function button:_hvShowItemTooltip()
        local item = self._hvItem
        local id = item and tonumber(item.itemID)
        if not id then return end
        ShowItemTooltip(self, id)
    end

    button:SetScript("OnEnter", function(selfBtn)
        if selfBtn.SetBackdropColor then
            selfBtn:SetBackdropColor(bgHover[1], bgHover[2], bgHover[3], bgHover[4])
        end
        if selfBtn.SetBackdropBorderColor then
            selfBtn:SetBackdropBorderColor(accent[1], accent[2], accent[3], 1)
        end
        selfBtn:_hvShowItemTooltip()
    end)

    button:SetScript("OnLeave", function(selfBtn)
        local rowBg = selfBtn._hvRowBg or bg
        local rowBorder = selfBtn._hvRowBorder or border
        if selfBtn.SetBackdropColor then
            selfBtn:SetBackdropColor(rowBg[1], rowBg[2], rowBg[3], rowBg[4])
        end
        if selfBtn.SetBackdropBorderColor then
            selfBtn:SetBackdropBorderColor(rowBorder[1], rowBorder[2], rowBorder[3], rowBorder[4])
        end
        if _G.GameTooltip and _G.GameTooltip.IsOwned and _G.GameTooltip:IsOwned(selfBtn) then
            _G.GameTooltip:Hide()
        end
    end)

    return button
end

function SimpleItemList:UpdateButton(button, item)
    button._hvItem = item

    local itemID = tonumber(item and item.itemID)
    button._hvItemID = itemID

    if itemID then
        RequestItemDataByID(itemID)
    end

    if button.icon then
        local tex = (item and (item.thumbnailFileID or item._thumbnailFileID)) or nil
        if tex then
            button.icon:SetTexture(tex)
        else
            local icon = itemID and GetItemIconByID(itemID) or nil
            button.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        end
    end

    local name = item and (item.name or item.itemName) or nil
    if name == "Unknown Item" or name == nil or name == "" then
        name = itemID and (GetItemRecordName(itemID) or GetItemNameByID(itemID)) or nil
    end
    if not name or name == "" then
        name = (itemID and self._hvNameCache and self._hvNameCache[itemID]) or (itemID and ("Item " .. tostring(itemID))) or "Item"
        if itemID and _G.C_Timer and _G.C_Timer.After and not self._hvNameRefreshPending[itemID] then
            self._hvNameRefreshPending[itemID] = true
            _G.C_Timer.After(0.25, function()
                self._hvNameRefreshPending[itemID] = nil
                if self.parentFrame and self.parentFrame.IsShown and self.parentFrame:IsShown() then
                    self:UpdateVisible()
                end
            end)
        end
    end
    if itemID and name and name ~= "" and name ~= ("Item " .. tostring(itemID)) and self._hvNameCache then
        self._hvNameCache[itemID] = name
    end

    local quality = item and (item._apiQuality or item.quality) or nil
    if quality == nil and itemID then
        quality = GetItemQualityByID(itemID)
    end
    if quality == nil and itemID and _G.C_Timer and _G.C_Timer.After and not self._hvQualityRefreshPending[itemID] then
        self._hvQualityRefreshPending[itemID] = true
        _G.C_Timer.After(0.25, function()
            self._hvQualityRefreshPending[itemID] = nil
            if self.parentFrame and self.parentFrame.IsShown and self.parentFrame:IsShown() then
                self:UpdateVisible()
            end
        end)
    end

    if button.nameText then
        local colorCode = GetQualityColorCode(quality)
        if colorCode then
            button.nameText:SetText(colorCode .. name .. "|r")
        else
            button.nameText:SetText(name)
        end
    end

    local hasMats = IsProfessionItem(item, itemID)
    local vendorName, zoneName, coords, waypointContext = GetBestWaypointContext(item, itemID, self._hvFilters, hasMats)
    if button.vendorText then
        button.vendorText:SetText(vendorName or "")
    end
    if button.zoneText then
        button.zoneText:SetText(zoneName or "")
    end

    local cx = coords and tonumber(coords.x) or nil
    local cy = coords and tonumber(coords.y) or nil
    local hasCoords = (cx ~= nil and cy ~= nil and cx > 0 and cy > 0)

    local pm = _G.HousingPlanManager
    local inPlan = pm and pm.IsInPlan and itemID and pm:IsInPlan(itemID) or false

    -- Plan is profession-only.
    SetActionShown(button.btnPlan, hasMats)

    if button.recipeText then
        local known = nil
        local hv = _G.HousingVendor
        local pr = hv and hv.ProfessionReagents
        local hasReagents = hasMats and pr and pr.HasReagents and itemID and pr:HasReagents(itemID) or false

        if hasReagents then
            if pr and pr.IsRecipeKnown then
                known = pr:IsRecipeKnown(itemID)
            end
            local theme = GetTheme()
            local colors = theme.Colors or {}
            local statusSuccess = colors.statusSuccess or { 0.30, 0.85, 0.50, 1.0 }

            if known == true then
                button.recipeText:SetText("Recipe Known")
                button.recipeText:SetTextColor(statusSuccess[1], statusSuccess[2], statusSuccess[3], 1)
                button.recipeText:Show()
            else
                button.recipeText:SetText("")
                button.recipeText:Hide()
            end
        else
            button.recipeText:SetText("")
            button.recipeText:Hide()
        end
    end

    if button.btnPlan and button.btnPlan.icon and hasMats then
        if inPlan then
            button.btnPlan.icon:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
            button.btnPlan.icon:SetTexCoord(0, 1, 0, 1)
            button.btnPlan.tooltipText = "Remove from Crafting List\nStops tracking this decor in your Craft List."
        else
            button.btnPlan.icon:SetTexture("Interface\\AddOns\\HousingVendor\\Data\\Media\\add.tga")
            button.btnPlan.icon:SetTexCoord(0, 1, 0, 1)
            button.btnPlan.tooltipText = "Add to Crafting List\nTracks this decor as something you plan to craft.\nOpen Craft List to see combined materials and costs."
        end
    end

    SetActionShown(button.btnWaypoint, hasCoords)
    SetActionShown(button.btnMark, hasCoords and waypointContext == "vendor")
    SetActionShown(button.btnMats, hasMats)
    LayoutActionBar(button)

    if button.btnWaypoint then
        button.btnWaypoint.tooltipText = (waypointContext == "trainer")
            and "Set Waypoint (Trainer)\nSets a waypoint to the trainer who teaches this recipe (when available)."
            or "Set Waypoint\nSets a waypoint to the best vendor for this item (based on your current filters)."
    end

    if button.btnPlan then
        button.btnPlan:SetScript("OnClick", function()
            if not itemID then return end
            local mgr = _G.HousingPlanManager
            if mgr and mgr.ToggleItem then
                mgr:ToggleItem(itemID)
                self:UpdateButton(button, item)
            end
        end)
    end

    if button.btnWaypoint then
        button.btnWaypoint:SetScript("OnClick", function()
            if not (item and hasCoords) then return end
            local temp = {
                coords = coords,
                mapID = coords.mapID or item.mapID or item.zoneMapID,
                vendorName = vendorName,
                npcID = item.npcID,
                expansionName = item.expansionName,
            }
            if _G.HousingWaypointManager and _G.HousingWaypointManager.SetWaypoint then
                _G.HousingWaypointManager:SetWaypoint(temp)
            end
        end)
    end

    if button.btnMark then
        button.btnMark:SetScript("OnClick", function()
            if not item then return end
            if _G.HousingVendorMarker and _G.HousingVendorMarker.ShowForVendor then
                _G.HousingVendorMarker:ShowForVendor(vendorName, item.npcID, coords)
            end
        end)
    end

    if button.btnMats then
        button.btnMats:SetScript("OnClick", function()
            if not itemID then return end
            if _G.HousingMaterialsTrackerUI and _G.HousingMaterialsTrackerUI.ToggleForItem then
                _G.HousingMaterialsTrackerUI:ToggleForItem(itemID)
            end
        end)
    end

    -- Compact list intentionally does not render costs/currencies or AH prices; click-through details show pricing.
end

function SimpleItemList:UpdateVisible()
    if not (self.container and self.scrollFrame) then return end

    local scrollOffset = self.scrollFrame:GetVerticalScroll()
    local startIndex = math.floor(scrollOffset / (BUTTON_HEIGHT + BUTTON_SPACING)) + 1
    local endIndex = math.min(startIndex + VISIBLE_BUTTONS, #self.filteredItems)

    for idx = 1, #self.buttons do
        if self.buttons[idx] then
            self.buttons[idx]:Hide()
        end
    end

    if #self.filteredItems == 0 then
        if not self.container.emptyText then
            local colors = (GetTheme().Colors or {})
            local textMuted = colors.textMuted or { 0.50, 0.48, 0.58, 1.0 }
            local t = self.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            t:SetPoint("TOPLEFT", self.container, "TOPLEFT", 10, -10)
            t:SetTextColor(textMuted[1], textMuted[2], textMuted[3], 1)
            t:SetText("No items match the current filters.")
            self.container.emptyText = t
        end
        self.container.emptyText:Show()
        return
    elseif self.container.emptyText then
        self.container.emptyText:Hide()
    end

    for i = startIndex, endIndex do
        local buttonIndex = i - startIndex + 1
        if not self.buttons[buttonIndex] then
            self.buttons[buttonIndex] = self:CreateButton(buttonIndex)
        end

        local button = self.buttons[buttonIndex]
        local entry = self.filteredItems[i]
        local item = entry
        if type(entry) == "number" and _G.HousingDataManager and _G.HousingDataManager.GetItemRecord then
            item = _G.HousingDataManager:GetItemRecord(entry)
        end

        if item then
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", self.container, "TOPLEFT", 10, -(i - 1) * (BUTTON_HEIGHT + BUTTON_SPACING))
            local w = (self.container:GetWidth() or 0) - 20
            if w < 1 then w = 1 end
            button:SetWidth(w)
            self:UpdateButton(button, item)
            button:Show()
        else
            button:Hide()
        end
    end
end

ns.SimpleItemList = SimpleItemList
_G.HousingSimpleItemList = SimpleItemList

return SimpleItemList
