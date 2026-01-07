-- Housing Collection API Module
-- Centralized collection status detection and caching

local HousingCollectionAPI = {}
HousingCollectionAPI.__index = HousingCollectionAPI

-- TAINT FIX: Global safety flag to prevent calling Housing APIs before delay period
-- This flag is shared across the entire addon to prevent race conditions
-- Flag starts as false, will be set to true after 3-second delay in Initialize()
_G.HousingCatalogSafeToCall = false

-- Session caches (cleared on reload)
local sessionCollectionCache = {}  -- itemID -> boolean (is collected)
local OWNED_DECOR_CACHE_TTL = 600  -- Cache TTL in seconds (refresh every 10 minutes)
local ownedCacheRefreshInProgress = false
local decorIDToItemIDCache = nil

-- Persistent cache support (stored in HousingDB.collectedDecor)
local persistentCacheEnabled = true  -- Enable persistent cache to fix collection detection issues

-- PERFORMANCE: Flag to disable EventRegistry callback when UI/zone popup are both closed
local eventHandlersActive = false

-- Helper: Get itemID from decorID using HousingAllItems
local function GetItemIDFromDecorID(decorID)
    if not HousingAllItems or not decorID then
        return nil
    end

    -- Search through HousingAllItems to find itemID for this decorID
    for itemID, decorData in pairs(HousingAllItems) do
        if decorData then
            local dataDecorID = decorData.decorID or decorData[1]
            if dataDecorID == decorID then
            return tonumber(itemID)
            end
        end
    end

    return nil
end

-- Helper: Get decorID from itemID using HousingAllItems
local function GetDecorIDFromItemID(itemID)
    if not HousingAllItems or not itemID then
        return nil
    end

    local numericItemID = tonumber(itemID)
    if not numericItemID then
        return nil
    end

    local decorData = HousingAllItems[numericItemID]
    if decorData and decorData[1] then  -- Index 1 = decorID (HousingItemFields.DECOR_ID)
        return decorData[1]
    end
    
    return nil
end

-- Check if item is cached as collected (checks both session and persistent cache)
local function IsItemCached(itemID)
    -- Check session cache first (fastest)
    if sessionCollectionCache[itemID] == true then
        return true
    end

    -- Check persistent cache (HousingDB.collectedDecor)
    if persistentCacheEnabled and HousingDB and HousingDB.collectedDecor then
        if HousingDB.collectedDecor[itemID] == true then
            -- Also cache in session for faster future lookups
            sessionCollectionCache[itemID] = true
            return true
        end
    end

    return false
end

-- Mark item as collected in both session and persistent cache
local function CacheItemAsCollected(itemID)
    -- Cache in session (fast lookups)
    sessionCollectionCache[itemID] = true

    -- Also cache persistently to SavedVariables (survives reload/logout)
    if persistentCacheEnabled and HousingDB then
        if not HousingDB.collectedDecor then
            HousingDB.collectedDecor = {}
        end
        HousingDB.collectedDecor[itemID] = true
    end

    -- Invalidate filter cache so collection filter can re-run with updated status
    -- This ensures that when items are cached (via tooltip callbacks or API checks),
    -- the filter will use the updated collection status on next application
    if HousingDataManager and HousingDataManager.InvalidateFilterCache then
        HousingDataManager:InvalidateFilterCache()
    end
end

local function EnsureOwnedCacheTables()
    if not HousingDB then
        HousingDB = {}
    end
    if not HousingDB.ownedDecorCache then
        HousingDB.ownedDecorCache = {
            lastScan = 0,
            items = {},
        }
    elseif not HousingDB.ownedDecorCache.items then
        HousingDB.ownedDecorCache.items = {}
    end
end

local function GetOwnedCacheEntry(itemID)
    if HousingDB and HousingDB.ownedDecorCache and HousingDB.ownedDecorCache.items then
        return HousingDB.ownedDecorCache.items[itemID]
    end
    return nil
end

local function BuildDecorIDToItemIDMap()
    if decorIDToItemIDCache then
        return decorIDToItemIDCache
    end

    local map = {}
    if HousingAllItems then
        for itemID, decorData in pairs(HousingAllItems) do
            local numericItemID = tonumber(itemID)
            if numericItemID and decorData then
                local decorID = decorData.decorID or decorData[1]
                if decorID then
                    map[decorID] = numericItemID
                end
            end
        end
    end

    decorIDToItemIDCache = map
    return map
end

-- Prime housing catalog searcher (caches decor data)
-- Being aggressive with creating searchers is fine - recache on zone transitions and searcher release
local function PrimeHousingCatalog()
    -- TAINT FIX: Safety check before calling Housing APIs
    if not _G.HousingCatalogSafeToCall then
        return
    end

    if not C_HousingCatalog then
        return
    end

    if C_HousingCatalog.CreateCatalogSearcher then
        pcall(C_HousingCatalog.CreateCatalogSearcher)
    end
end

local function ConfigureCatalogSearcherForOwnedDecor(catalogSearcher)
    if not catalogSearcher then
        return false
    end

    catalogSearcher:SetOwnedOnly(true)
    catalogSearcher:SetIncludeMarketEntries(false)
    catalogSearcher:SetFilteredCategoryID(nil)
    catalogSearcher:SetFilteredSubcategoryID(nil)
    catalogSearcher:SetSearchText(nil)
    catalogSearcher:SetCustomizableOnly(false)
    catalogSearcher:SetAllowedIndoors(true)
    catalogSearcher:SetAllowedOutdoors(true)
    catalogSearcher:SetCollected(true)
    catalogSearcher:SetUncollected(true)
    catalogSearcher:SetFirstAcquisitionBonusOnly(false)

    local filterTagGroups = C_HousingCatalog.GetAllFilterTagGroups and C_HousingCatalog.GetAllFilterTagGroups() or nil
    if filterTagGroups then
        for _, tagGroup in ipairs(filterTagGroups) do
            catalogSearcher:SetAllInFilterTagGroup(tagGroup.groupID, true)
        end
    end

    return true
end

local function ExtractOwnedDecorEntriesFromSearcher(catalogSearcher)
    local entries = {}
    if not catalogSearcher or not catalogSearcher.GetAllSearchItems then
        return entries
    end

    local allItems = catalogSearcher:GetAllSearchItems()
    if not allItems or #allItems == 0 then
        return entries
    end

    local decorMap = BuildDecorIDToItemIDMap()

    for _, entryID in ipairs(allItems) do
        if entryID and entryID.entryType == Enum.HousingCatalogEntryType.Decor then
            local ok, entryInfo = pcall(C_HousingCatalog.GetCatalogEntryInfo, entryID)
            if ok and entryInfo then
                local numPlaced = entryInfo.numPlaced or 0
                local quantity = entryInfo.quantity or 0
                local remainingRedeemable = entryInfo.remainingRedeemable or 0
                local stored = quantity + remainingRedeemable
                local totalOwned = numPlaced + stored

                if totalOwned > 0 then
                    local itemID = nil
                    if entryInfo.itemID then
                        itemID = tonumber(entryInfo.itemID)
                    elseif entryID.itemID then
                        itemID = tonumber(entryID.itemID)
                    elseif entryID.recordID then
                        itemID = decorMap[entryID.recordID] or GetItemIDFromDecorID(entryID.recordID)
                    end

                    if itemID then
                        entries[itemID] = {
                            numStored = entryInfo.numStored or 0,
                            numPlaced = numPlaced,
                            quantity = quantity,
                            remainingRedeemable = remainingRedeemable,
                            totalOwned = totalOwned,
                        }
                    end
                end
            end
        end
    end

    return entries
end

------------------------------------------------------------
-- Helper: Get catalog entry state for an itemID
-- Consolidates the repeated logic for checking catalog entries
-- Returns: state table with numStored, numPlaced, or nil if not found
------------------------------------------------------------
local function GetCatalogEntryState(numericItemID)
    -- TAINT FIX: Don't call Housing APIs before safe delay period
    if not _G.HousingCatalogSafeToCall then
        return nil
    end

    if not numericItemID or not C_HousingCatalog then
        return nil
    end

    -- Request item data to be loaded first
    if C_Item and C_Item.RequestLoadItemDataByID then
        C_Item.RequestLoadItemDataByID(numericItemID)
    end

    local state = nil

    -- Method 1: Try GetCatalogEntryInfoByItem FIRST (uses itemID directly)
    -- This is more reliable for items not in HousingAllItems and doesn't depend on decorID
    -- TAINT FIX: Check safety flag BEFORE accessing C_HousingCatalog (even existence checks)
    if C_HousingCatalog and C_HousingCatalog.GetCatalogEntryInfoByItem then
        PrimeHousingCatalog()
        local success, itemState = pcall(function()
            return C_HousingCatalog.GetCatalogEntryInfoByItem(numericItemID, true)
        end)
        if success and itemState then
            state = itemState
        end
    end

    -- Method 2: Fallback to GetCatalogEntryInfoByRecordID (uses decorID, requires static data)
    if not state and C_HousingCatalog and C_HousingCatalog.GetCatalogEntryInfoByRecordID then
        local baseInfo = nil
        local decorID = nil

        -- Try HousingAPI first
        if HousingAPI then
            baseInfo = HousingAPI:GetDecorItemInfoFromItemID(numericItemID)
            if baseInfo and baseInfo.decorID then
                decorID = baseInfo.decorID
            end
        end

        -- Fallback to HousingAllItems
        if not decorID then
            decorID = GetDecorIDFromItemID(numericItemID)
        end

        if decorID then
            local decorType = Enum.HousingCatalogEntryType.Decor
            PrimeHousingCatalog()
            local success, recordState = pcall(function()
                return C_HousingCatalog.GetCatalogEntryInfoByRecordID(decorType, decorID, true)
            end)
            if success and recordState then
                state = recordState
            end
        end
    end

    return state
end

-- Force recache catalog searcher (call on zone transitions and HOUSING_CATALOG_SEARCHER_RELEASED)
local function ForceRecacheCatalogSearcher()
    -- TAINT FIX: Safety check before calling Housing APIs
    if not _G.HousingCatalogSafeToCall then
        return
    end

    if not C_HousingCatalog then
        return
    end

    if C_HousingCatalog.CreateCatalogSearcher then
        pcall(C_HousingCatalog.CreateCatalogSearcher)
    end
end

------------------------------------------------------------
-- Event Handling (lifecycle-controlled)
------------------------------------------------------------

local eventFrame = nil
local housingCatalogUpdatedRegistered = false

local function EnsureEventFrame()
    if not eventFrame then
        eventFrame = CreateFrame("Frame")
    end
    return eventFrame
end

local function HandleEvent(self, event, ...)
    if event == "HOUSING_CATALOG_SEARCHER_RELEASED" then
        -- Force recache when searcher is released
        ForceRecacheCatalogSearcher()
    elseif event == "HOUSING_STORAGE_UPDATED" then
        -- This event triggers twice, so add delay
        -- Refresh collection status after storage update
        C_Timer.After(2, function()
            HousingCollectionAPI:RefreshOwnedDecorCache(nil, true)
        end)
    elseif event == "HOUSING_CATALOG_UPDATED" and housingCatalogUpdatedRegistered then
        -- Clear session cache when catalog updates (persistent cache remains)
        -- Only handle if event was successfully registered (Midnight API)
        HousingCollectionAPI:ClearSessionCache()
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
        -- Recache on zone transitions (being aggressive is fine)
        C_Timer.After(0.5, function()
            ForceRecacheCatalogSearcher()
        end)
    elseif event == "PLAYER_LOGOUT" then
        -- Clear session cache on logout (persistent cache is saved automatically)
        HousingCollectionAPI:ClearSessionCache()
    end
end

------------------------------------------------------------
-- Public API: Check if item is collected (returns boolean)
------------------------------------------------------------

function HousingCollectionAPI:IsItemCollected(itemID)
    if not itemID or itemID == "" then
        return false
    end

    local numericItemID = tonumber(itemID)
    if not numericItemID then
        return false
    end

    -- Request item data to be loaded first (important after cache deletion)
    if C_Item and C_Item.RequestLoadItemDataByID then
        C_Item.RequestLoadItemDataByID(numericItemID)
    end

    -- Check local cache first (avoid repeated API calls)
    -- This checks both session and persistent cache
    if IsItemCached(numericItemID) then
        return true
    end

    -- Check owned decor cache (catalog searcher snapshot)
    local ownedEntry = GetOwnedCacheEntry(numericItemID)
    if ownedEntry and (ownedEntry.totalOwned or 0) > 0 then
        CacheItemAsCollected(numericItemID)
        return true
    end

    -- Skip HousingAPICache - go directly to API calls for more reliable results
    -- (HousingAPICache has TTL which can cause stale data)

    -- Fallback to direct API calls
    local isCollected = false

    -- Method 1: Check catalog entry (numStored + numPlaced) - MOST RELIABLE
    -- This is the primary method for filtering and should be tried first
    local state = GetCatalogEntryState(numericItemID)
    if state then
        local sum = (state.numStored or 0) + (state.numPlaced or 0)
        if sum > 0 and sum < 1000000 then
            isCollected = true
            CacheItemAsCollected(numericItemID)
        end
    end

    -- Method 2: Use C_Housing.IsDecorCollected (correct API for housing decor)
    if not isCollected and _G.HousingCatalogSafeToCall and C_Housing and C_Housing.IsDecorCollected then
        local success, collected = pcall(function()
            return C_Housing.IsDecorCollected(numericItemID)
        end)
        if success and collected ~= nil then
            isCollected = collected
            if isCollected then
                CacheItemAsCollected(numericItemID)
            end
        end
    end

    -- Method 3: Fallback to housing catalog API (alternative method)
    -- TAINT FIX: Only call if safe delay period has passed
    if not isCollected and _G.HousingCatalogSafeToCall and C_HousingCatalog and C_HousingCatalog.GetCatalogEntryByItemID then
        PrimeHousingCatalog()
        local success, entryInfo = pcall(function()
            return C_HousingCatalog.GetCatalogEntryByItemID(numericItemID)
        end)
        if success and entryInfo then
            if entryInfo.isCollected ~= nil then
                isCollected = entryInfo.isCollected
                if isCollected then
                    CacheItemAsCollected(numericItemID)
                end
            elseif entryInfo.collected ~= nil then
                isCollected = entryInfo.collected
                if isCollected then
                    CacheItemAsCollected(numericItemID)
                end
            end
        end
    end

    -- Method 5: Fallback to generic item collection API (for non-decor items)
    if not isCollected and _G.HousingCatalogSafeToCall and C_PlayerInfo and C_PlayerInfo.IsItemCollected then
        local success, collected = pcall(function()
            return C_PlayerInfo.IsItemCollected(numericItemID)
        end)
        if success and collected ~= nil then
            isCollected = collected
            if isCollected then
                CacheItemAsCollected(numericItemID)
            end
        end
    end

    return isCollected
end

------------------------------------------------------------
-- Public API: Get detailed collection info
------------------------------------------------------------

function HousingCollectionAPI:GetCollectionInfo(itemID)
    if not itemID or itemID == "" then
        return {
            isCollected = false,
            numStored = 0,
            numPlaced = 0,
            totalOwned = 0
        }
    end

    local numericItemID = tonumber(itemID)
    if not numericItemID then
        return {
            isCollected = false,
            numStored = 0,
            numPlaced = 0,
            totalOwned = 0
        }
    end

    -- Request item data to be loaded first (important after cache deletion)
    if C_Item and C_Item.RequestLoadItemDataByID then
        C_Item.RequestLoadItemDataByID(numericItemID)
    end

    -- Check cache first
    local isCollected = IsItemCached(numericItemID)
    local numStored = 0
    local numPlaced = 0

    -- Check owned decor cache first for reliable placement counts
    local ownedEntry = GetOwnedCacheEntry(numericItemID)
    if ownedEntry then
        numStored = ownedEntry.numStored or 0
        numPlaced = ownedEntry.numPlaced or 0
        if (ownedEntry.totalOwned or 0) > 0 then
            isCollected = true
            CacheItemAsCollected(numericItemID)
        end
    end

    -- If cached, try to get quantity info from API
    if isCollected and not ownedEntry then
        if HousingAPI then
            local state = HousingAPI:GetCatalogEntryInfoByItem(numericItemID)
            if state then
                numStored = state.numStored or 0
                numPlaced = state.numPlaced or 0
            end
        end
    else
        -- Not cached, query API using consolidated helper
        local state = GetCatalogEntryState(numericItemID)

        if state then
            numStored = state.numStored or 0
            numPlaced = state.numPlaced or 0
            local sum = numStored + numPlaced
            if sum > 0 and sum < 1000000 then
                isCollected = true
                CacheItemAsCollected(numericItemID)
            end
        end
    end

    local totalOwned = numStored + numPlaced

    return {
        isCollected = isCollected,
        numStored = numStored,
        numPlaced = numPlaced,
        totalOwned = totalOwned
    }
end

------------------------------------------------------------
-- Public API: Manually mark item as collected
------------------------------------------------------------

function HousingCollectionAPI:MarkItemCollected(itemID)
    if not itemID or itemID == "" then
        return
    end

    local numericItemID = tonumber(itemID)
    if not numericItemID then
        return
    end

    CacheItemAsCollected(numericItemID)
end

------------------------------------------------------------
-- Public API: Clear collection cache
------------------------------------------------------------

function HousingCollectionAPI:ClearCache(itemID)
    if itemID then
        local numericItemID = tonumber(itemID)
        if numericItemID then
            -- Clear from persistent cache
            if HousingDB and HousingDB.collectedDecor then
                HousingDB.collectedDecor[numericItemID] = nil
            end
            -- Clear from session cache
            sessionCollectionCache[numericItemID] = nil
        end
    else
        -- Clear all caches
        if HousingDB and HousingDB.collectedDecor then
            HousingDB.collectedDecor = {}
        end
        wipe(sessionCollectionCache)
    end
end

------------------------------------------------------------
-- Public API: Clear session cache only (keeps persistent cache)
------------------------------------------------------------

function HousingCollectionAPI:ClearSessionCache()
    wipe(sessionCollectionCache)
end

------------------------------------------------------------
-- Public API: Get cache statistics
------------------------------------------------------------

function HousingCollectionAPI:GetCacheStats()
    local persistentCount = 0
    if HousingDB and HousingDB.collectedDecor then
        for _ in pairs(HousingDB.collectedDecor) do
            persistentCount = persistentCount + 1
        end
    end
    
    local sessionCount = 0
    for _ in pairs(sessionCollectionCache) do
        sessionCount = sessionCount + 1
    end
    
    return {
        persistent = persistentCount,
        session = sessionCount,
        total = persistentCount + sessionCount
    }
end

------------------------------------------------------------
-- Public API: Get collection status using HousingAPI wrapper
-- (for compatibility with existing code that uses HousingAPI)
------------------------------------------------------------

function HousingCollectionAPI:IsItemCollectedViaHousingAPI(itemID)
    if not itemID or itemID == "" then
        return false
    end

    local numericItemID = tonumber(itemID)
    if not numericItemID then
        return false
    end

    -- Check cache first
    if IsItemCached(numericItemID) then
        return true
    end

    -- Use HousingAPI wrapper
    if HousingAPI then
        local baseInfo = HousingAPI:GetDecorItemInfoFromItemID(numericItemID)
        if baseInfo and baseInfo.decorID then
            local collected = HousingAPI:IsDecorCollected(baseInfo.decorID)
            if collected ~= nil then
                if collected then
                    CacheItemAsCollected(numericItemID)
                end
                return collected
            end
        end

        -- Fallback: Use consolidated catalog entry helper
        local state = GetCatalogEntryState(numericItemID)
        if state then
            local sum = (state.numStored or 0) + (state.numPlaced or 0)
            if sum > 0 and sum < 1000000 then
                CacheItemAsCollected(numericItemID)
                return true
            end
        end
    end

    return false
end

------------------------------------------------------------
-- Public API: Force recache for specific item
------------------------------------------------------------

function HousingCollectionAPI:ForceRecache(itemID)
    if not itemID or itemID == "" then
        return
    end

    local numericItemID = tonumber(itemID)
    if not numericItemID then
        return
    end

    -- Clear cache for this item
    if HousingDB and HousingDB.collectedDecor then
        HousingDB.collectedDecor[numericItemID] = nil
    end

    -- Re-check collection status
    return self:IsItemCollected(numericItemID)
end

------------------------------------------------------------
-- Public API: Force recache catalog searcher
------------------------------------------------------------

function HousingCollectionAPI:RecacheCatalogSearcher()
    ForceRecacheCatalogSearcher()
end

------------------------------------------------------------
-- Public API: Refresh owned decor cache (catalog searcher snapshot)
------------------------------------------------------------

function HousingCollectionAPI:RefreshOwnedDecorCache(callback, force)
    if ownedCacheRefreshInProgress then
        if callback then
            callback(false, 0, 0, "Scan already in progress")
        end
        return
    end

    if not _G.HousingCatalogSafeToCall then
        if callback then
            callback(false, 0, 0, "Housing Catalog API not safe to call yet")
        end
        return
    end

    if not C_HousingCatalog or not C_HousingCatalog.CreateCatalogSearcher then
        if callback then
            callback(false, 0, 0, "Housing Catalog API not available")
        end
        return
    end

    EnsureOwnedCacheTables()

    local now = time()
    local cacheAge = now - (HousingDB.ownedDecorCache.lastScan or 0)
    if not force and HousingDB.ownedDecorCache.items and next(HousingDB.ownedDecorCache.items) ~= nil and cacheAge < OWNED_DECOR_CACHE_TTL then
        if callback then
            callback(true, 0, 0, nil)
        end
        return
    end

    ownedCacheRefreshInProgress = true

    local catalogSearcher = C_HousingCatalog.CreateCatalogSearcher()
    if not catalogSearcher then
        ownedCacheRefreshInProgress = false
        if callback then
            callback(false, 0, 0, "Failed to create catalog searcher")
        end
        return
    end

    ConfigureCatalogSearcherForOwnedDecor(catalogSearcher)

    catalogSearcher:SetResultsUpdatedCallback(function()
        local entries = ExtractOwnedDecorEntriesFromSearcher(catalogSearcher)

        local prevCollected = 0
        if HousingDB and HousingDB.collectedDecor then
            for _ in pairs(HousingDB.collectedDecor) do
                prevCollected = prevCollected + 1
            end
        end

        HousingDB.ownedDecorCache.items = entries
        HousingDB.ownedDecorCache.lastScan = time()

        local scanned = 0
        for itemID, data in pairs(entries) do
            scanned = scanned + 1
            if data and (data.totalOwned or 0) > 0 then
                CacheItemAsCollected(itemID)
            end
        end

        local newCollected = 0
        if HousingDB and HousingDB.collectedDecor then
            for _ in pairs(HousingDB.collectedDecor) do
                newCollected = newCollected + 1
            end
        end

        ownedCacheRefreshInProgress = false
        if catalogSearcher.Release then
            catalogSearcher:Release()
        end

        if callback then
            callback(true, scanned, math.max(newCollected - prevCollected, 0), nil)
        end
    end)

    if catalogSearcher.RunSearch then
        pcall(function()
            catalogSearcher:RunSearch()
        end)
    else
        ownedCacheRefreshInProgress = false
        if catalogSearcher.Release then
            catalogSearcher:Release()
        end
        if callback then
            callback(false, 0, 0, "Unable to run catalog search")
        end
    end
end

------------------------------------------------------------
-- Public API: Batch refresh collection status
-- Refreshes collection status for a list of itemIDs
------------------------------------------------------------

function HousingCollectionAPI:BatchRefreshCollectionStatus(itemIDs)
    if not itemIDs or #itemIDs == 0 then
        return {}
    end

    local refreshed = {}
    PrimeHousingCatalog()

    for _, itemID in ipairs(itemIDs) do
        local numericItemID = tonumber(itemID)
        if numericItemID and not IsItemCached(numericItemID) then
            -- Check collection status (will cache if collected)
            local isCollected = self:IsItemCollected(numericItemID)
            if isCollected then
                table.insert(refreshed, numericItemID)
            end
        end
    end

    return refreshed
end

function HousingCollectionAPI:ScanAllDecorItems(callback)
    self:RefreshOwnedDecorCache(callback, true)
end

function HousingCollectionAPI:StartEventHandlers()
    local frame = EnsureEventFrame()
    frame:SetScript("OnEvent", HandleEvent)

    -- Register core events
    -- Midnight Beta 5 (12.0.1) removes HOUSING_CATALOG_SEARCHER_RELEASED.
    -- Gate by TOC so we don't rely on an event that no longer fires.
    local _, _, _, tocVersion = GetBuildInfo()
    tocVersion = tonumber(tocVersion) or 0
    if tocVersion > 0 and tocVersion < 120001 then
        frame:RegisterEvent("HOUSING_CATALOG_SEARCHER_RELEASED")
    end
    frame:RegisterEvent("HOUSING_STORAGE_UPDATED")
    frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_LOGOUT")

    -- Conditionally register Midnight API event (only if available)
    do
        local canRegister = true
        if _G.C_EventUtils and _G.C_EventUtils.IsEventValid then
            local ok, valid = pcall(_G.C_EventUtils.IsEventValid, "HOUSING_CATALOG_UPDATED")
            if ok and valid == false then
                canRegister = false
            end
        end
        if canRegister then
            local success = pcall(function()
                frame:RegisterEvent("HOUSING_CATALOG_UPDATED")
                housingCatalogUpdatedRegistered = true
            end)
            if not success then
                housingCatalogUpdatedRegistered = false
            end
        else
            housingCatalogUpdatedRegistered = false
        end
    end

    eventHandlersActive = true  -- Enable EventRegistry callback processing
end

function HousingCollectionAPI:StopEventHandlers()
    if eventFrame then
        eventFrame:UnregisterAllEvents()
    end
    housingCatalogUpdatedRegistered = false
    eventHandlersActive = false  -- Disable EventRegistry callback processing
end

------------------------------------------------------------
-- Housing Catalog Tooltip Callback
-- Cache collection status when tooltips are shown in housing catalog UI
-- This provides passive collection updates when users browse the catalog
------------------------------------------------------------

local function RegisterTooltipCallback()
    if not _G.HousingCatalogSafeToCall then
        return
    end

    if EventRegistry and EventRegistry.RegisterCallback then
        EventRegistry:RegisterCallback("HousingCatalogEntry.TooltipCreated", function(val1, entryFrame, tooltip)
            -- PERFORMANCE: Don't process when event handlers are stopped (UI and zone popup both closed)
            if not eventHandlersActive then
                return
            end

            -- Don't process when house editor is active (unnecessary)
            if _G.HousingCatalogSafeToCall and C_HouseEditor and C_HouseEditor.IsHouseEditorActive and C_HouseEditor.IsHouseEditorActive() then
                return
            end

            -- CRITICAL FIX: Don't process tooltips when they originate from Blizzard bag/inventory UI
            -- This prevents UI taint that blocks secure actions like learning mounts from bags
            -- Only process tooltips that come from the housing catalog UI itself
            if tooltip then
                local owner = tooltip:GetOwner()
                if owner then
                    local ownerName = owner:GetName()
                    -- Block processing if tooltip owner is a Blizzard container/bag button
                    -- This prevents interference with UseContainerItem and similar secure functions
                    if ownerName and (
                        string.find(ownerName, "ContainerFrame") or
                        string.find(ownerName, "BagItem") or
                        string.find(ownerName, "BankItem") or
                        string.find(ownerName, "BackpackItem") or
                        string.find(ownerName, "ReagentBankItem") or
                        string.find(ownerName, "ItemButton")
                    ) then
                        return
                    end
                end
            end

            if not entryFrame or not entryFrame.entryInfo then
                return
            end

            local entryInfo = entryFrame.entryInfo

            -- Check collection status from tooltip entryInfo
            -- This provides passive collection updates when users browse the catalog
            if entryInfo.numStored or entryInfo.numPlaced then
                local numStored = entryInfo.numStored or 0
                local numPlaced = entryInfo.numPlaced or 0
                local sum = numStored + numPlaced

                if sum > 0 and sum < 1000000 then
                    -- Try multiple methods to get itemID
                    local itemID = nil

                    -- Method 1: Direct itemID from entryInfo
                    if entryInfo.itemID then
                        itemID = entryInfo.itemID
                    end

                    -- Method 2: Try to get from entryID.itemID
                    if not itemID and entryInfo.entryID and entryInfo.entryID.itemID then
                        itemID = entryInfo.entryID.itemID
                    end

                    -- Method 3: If we have decorID, try to look up itemID via HousingAllItems
                    if not itemID and entryInfo.entryID and entryInfo.entryID.recordID then
                        local decorID = entryInfo.entryID.recordID
                        itemID = GetItemIDFromDecorID(decorID)
                    end

                    -- Method 4: Try to extract from tooltip text (last resort)
                    if not itemID and tooltip and tooltip.TextLeft1 then
                        -- Tooltip might have item link we can parse
                        local tooltipText = tooltip.TextLeft1:GetText()
                        if tooltipText then
                            -- Look for item link pattern: |Hitem:ITEMID:...
                            local itemLinkPattern = "|Hitem:(%d+):"
                            local foundID = tooltipText:match(itemLinkPattern)
                            if foundID then
                                itemID = tonumber(foundID)
                            end
                        end
                    end

                    -- If we have itemID, cache it immediately (passive update)
                    if itemID then
                        local numericItemID = tonumber(itemID)
                        if numericItemID then
                            CacheItemAsCollected(numericItemID)

                        end
                    end
                end
            end
        end)
    end
end

------------------------------------------------------------
-- Initialize Collection Cache
------------------------------------------------------------

-- Initialize persistent collection cache on addon load
local function InitializeCollectionCache()
    -- Ensure HousingDB exists
    if not HousingDB then
        return
    end

    -- Create collectedDecor table if it doesn't exist
    if not HousingDB.collectedDecor then
        HousingDB.collectedDecor = {}
    end

    -- Load persistent cache into session cache for faster lookups
    local loadedCount = 0
    if HousingDB.collectedDecor then
        for itemID, isCollected in pairs(HousingDB.collectedDecor) do
            if isCollected == true then
                sessionCollectionCache[itemID] = true
                loadedCount = loadedCount + 1
            end
        end
    end

    -- Debug: Report cache initialization
    if loadedCount > 0 then
        print(string.format("|cFF8A7FD4HousingVendor:|r Loaded %d collected items from cache", loadedCount))
    end
end

------------------------------------------------------------
-- Force Refresh Collection Cache
------------------------------------------------------------

-- Force refresh collection cache by re-querying API for all known items
-- This is called when the outstanding items popup is about to show
function HousingCollectionAPI:ForceRefresh()
    -- No-op for now - the persistent cache is already loaded
    -- Individual items will be queried on-demand and cached automatically
    -- This function exists to satisfy the call in Events.lua line 103
end

------------------------------------------------------------
-- Get Cache Statistics
------------------------------------------------------------

function HousingCollectionAPI:GetCacheStats()
    local sessionCount = 0
    for _ in pairs(sessionCollectionCache) do
        sessionCount = sessionCount + 1
    end

    local persistentCount = 0
    if HousingDB and HousingDB.collectedDecor then
        for _ in pairs(HousingDB.collectedDecor) do
            persistentCount = persistentCount + 1
        end
    end

    return {
        session = sessionCount,
        persistent = persistentCount,
        total = persistentCount,  -- Total is persistent count (session is subset)
    }
end

------------------------------------------------------------
-- Initialize
------------------------------------------------------------

function HousingCollectionAPI:Initialize()
    InitializeCollectionCache()

    -- TAINT FIX: Set global safety flag after delay AND after Collections is opened once
    -- This timer MUST be created during Initialize() (ADDON_LOADED event), not at file load time
    -- 6 seconds ensures this completes AFTER zone popup's 4+1=5 second delay
    local REQUIRE_COLLECTIONS_SHOWN = false
    local safeDelayPassed = false
    local collectionsShownOnce = false
    local SAFE_DELAY_SECONDS = 6
    if HousingDB and HousingDB.settings and tonumber(HousingDB.settings.catalogSafeDelaySeconds) ~= nil then
        SAFE_DELAY_SECONDS = tonumber(HousingDB.settings.catalogSafeDelaySeconds) or SAFE_DELAY_SECONDS
    end

    local function TryEnableHousingCatalog()
        if _G.HousingCatalogSafeToCall then
            return
        end
        if not safeDelayPassed or (REQUIRE_COLLECTIONS_SHOWN and not collectionsShownOnce) then
            return
        end

        _G.HousingCatalogSafeToCall = true
        PrimeHousingCatalog()
        RegisterTooltipCallback()

        -- CRITICAL: Initialize other Housing modules AFTER safety flag is set
        -- This prevents any code from touching C_Housing* globals during ADDON_LOADED
        if HousingAPI and HousingAPI.Initialize then
            pcall(HousingAPI.Initialize, HousingAPI)
        end
        if HousingAPICache and HousingAPICache.Initialize then
            pcall(HousingAPICache.Initialize, HousingAPICache)
        end
        if HousingCatalogAPI and HousingCatalogAPI.Initialize then
            pcall(HousingCatalogAPI.Initialize, HousingCatalogAPI)
        end
        if HousingDecorAPI and HousingDecorAPI.Initialize then
            pcall(HousingDecorAPI.Initialize, HousingDecorAPI)
        end
        if HousingEditorAPI and HousingEditorAPI.Initialize then
            pcall(HousingEditorAPI.Initialize, HousingEditorAPI)
        end
        if HousingDataEnhancer and HousingDataEnhancer.Initialize then
            pcall(HousingDataEnhancer.Initialize, HousingDataEnhancer)
        end
    end

    local function MarkCollectionsShown()
        collectionsShownOnce = true
        TryEnableHousingCatalog()
    end

    local function WatchCollections()
        if _G.CollectionsJournal then
            _G.CollectionsJournal:HookScript("OnShow", MarkCollectionsShown)
            if _G.CollectionsJournal:IsShown() then
                MarkCollectionsShown()
            end
        end
    end

    local function OnCollectionsLoaded()
        WatchCollections()
    end

    local collectionsWatcher = CreateFrame("Frame")
    collectionsWatcher:RegisterEvent("ADDON_LOADED")
    collectionsWatcher:SetScript("OnEvent", function(_, event, name)
        if event == "ADDON_LOADED" and name == "Blizzard_Collections" then
            OnCollectionsLoaded()
        end
    end)

    if SAFE_DELAY_SECONDS <= 0 then
        safeDelayPassed = true
        TryEnableHousingCatalog()
    else
        C_Timer.After(SAFE_DELAY_SECONDS, function()
            safeDelayPassed = true
            TryEnableHousingCatalog()
        end)
    end
end

-- Make globally accessible
_G["HousingCollectionAPI"] = HousingCollectionAPI

-- Register mem stats
if _G.HousingMemReport and _G.HousingMemReport.Register then
    _G.HousingMemReport:Register("Collection", function()
        local stats = HousingCollectionAPI.GetCacheStats and HousingCollectionAPI:GetCacheStats() or nil
        if not stats then
            return { total = 0 }
        end
        return {
            total = stats.total or 0,
            persistent = stats.persistent or 0,
            session = stats.session or 0,
        }
    end)
end

-- REMOVED: Auto-initialize at file load time (causes taint)
-- Initialize() is now only called from Events.lua during ADDON_LOADED event
-- HousingCollectionAPI:Initialize()

return HousingCollectionAPI
