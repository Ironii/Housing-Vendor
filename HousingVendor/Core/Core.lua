local ADDON_NAME, ns = ...

local HousingVendorAddon = _G.HousingVendorAddon or {}
_G.HousingVendorAddon = HousingVendorAddon

-- Expose addon table for legacy modules that reference _G.HousingVendor
if not _G.HousingVendor then
    _G.HousingVendor = ns
end

HousingVendorAddon.version = " 07.01.26.04"

-- NOTE: Avoid creating generic globals like `_G.Housing` (can collide with Blizzard UI / other addons).

SLASH_HOUSINGVENDOR1 = "/hv"
SLASH_HOUSINGVENDOR2 = "/housingvendor"
SlashCmdList["HOUSINGVENDOR"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    
    if cmd == "help" then
        print("|cFF8A7FD4HousingVendor:|r Slash commands")
        print("  /hv - Toggle main UI")
        print("  /hv help - Show this help")
        print("  /hv version - Show addon version")
        print("  /hv mem [gc] - Show memory (optional GC)")
        print("  /hv diag - Debug DataManager/API state")
        print("  /hv stats - Completion stats")
        print("  /hv scan - Scan all decor items")
        print("  /hv ahscan [all|visible] [debug] [force] - Scan Auction House prices for profession decor (AH must be open)")
        print("  /hv ahbrowse [debug] - Import current AH browse list prices (select Housing -> Decor first)")
        print("  /hv ahscan status|stop - Show/stop AH scan")
        print("  /hv showall - Toggle showing unreleased items")
        print("  /hv api on|off - Toggle API calls")
        print("  /hv mark [name] - Open vendor marker UI")
        print("  /hv mats [wishlist|raw|<itemID>] - Materials tracker")
        print("  /hv debugnp [toggle] - Nameplate debug")
        print("  /hv zone [debug] - Zone popup (optional debug)")
        print("  /hv cost <itemID> - Cost debug")
        print("  /hv item <itemID> - Item debug")
        return
    end

    if cmd == "version" then
        print("Version: " .. (HousingVendorAddon.version or "unknown"))
    elseif cmd == "ahbrowse" then
        print("|cFFFFD100HousingVendor:|r AH browse import is disabled in this build.")
        print("|cFFFFD100HousingVendor:|r Install Auctionator or TSM, then use /hv ahscan all.")
        return
    elseif cmd == "ahscan" then
        local raw = (args and tostring(args)) or ""
        local lower = raw:lower()

        local function CountAuctionCache()
            local cache = HousingDB and HousingDB.auctionCache and HousingDB.auctionCache.items
            if type(cache) ~= "table" then
                return 0
            end
            local n = 0
            for _ in pairs(cache) do n = n + 1 end
            return n
        end

        if not HousingAuctionHouseAPI then
            print("|cFFFF4040HousingVendor:|r AuctionHouseAPI module missing")
            return
        end

        HousingAuctionHouseAPI:Initialize()
        if not (HousingAuctionHouseAPI.HasAddonPriceSource and HousingAuctionHouseAPI:HasAddonPriceSource()) then
            print("|cFFFFD100HousingVendor:|r AH scanning requires Auctionator or TSM in this build.")
            print("|cFFFFD100HousingVendor:|r Install one of them, then use /hv ahscan all.")
            return
        end

        if lower == "stop" then
            HousingAuctionHouseAPI:StopScan("slash_stop")
            print("|cFF8A7FD4HousingVendor:|r AH scan stopped.")
            return
        end

        if lower == "status" then
            local st = HousingAuctionHouseAPI.GetScanProgress and HousingAuctionHouseAPI:GetScanProgress() or nil
            local open = HousingAuctionHouseAPI:IsAuctionHouseOpen()
            local cached = CountAuctionCache()
            local maxAge = HousingDB and HousingDB.settings and tonumber(HousingDB.settings.ahPriceMaxAgeSeconds) or nil
            print("|cFF8A7FD4HousingVendor:|r AH scan status")
            print("  AH open=" .. tostring(open) .. " cachedPrices=" .. tostring(cached) .. " maxAgeSeconds=" .. tostring(maxAge))
            if st then
                print("  scanning=" .. tostring(st.isScanning) .. " index=" .. tostring(st.index) .. "/" .. tostring(st.total) ..
                    " pending=" .. tostring(st.pendingSearch) .. " itemID=" .. tostring(st.currentItemID))
            end
            return
        end

        if not HousingAuctionHouseAPI:IsAuctionHouseOpen() then
            local hasAddonPricing = HousingAuctionHouseAPI.HasAddonPriceSource and HousingAuctionHouseAPI:HasAddonPriceSource()
            if not hasAddonPricing then
                print("|cFFFF4040HousingVendor:|r Open the Auction House before scanning.")
                return
            end
        end

        local mode = "visible"
        if lower:find("full", 1, true) or lower:find("all", 1, true) then
            mode = "all"
        elseif lower:find("filtered", 1, true) or lower:find("visible", 1, true) then
            mode = "visible"
        end
        local debug = lower:find("debug", 1, true) ~= nil
        local force = lower:find("force", 1, true) ~= nil

        local function EnsureProfessionDataReady()
            if _G.HousingDataAggregator and _G.HousingDataAggregator.ProcessPendingData then
                pcall(_G.HousingDataAggregator.ProcessPendingData, _G.HousingDataAggregator)
            end
        end

        local function GetProfessionItemIDs()
            EnsureProfessionDataReady()
            local prof = _G.HousingProfessionData
            if type(prof) ~= "table" then
                return {}
            end
            local ids = {}
            for itemID in pairs(prof) do
                local idNum = tonumber(itemID)
                if idNum then
                    ids[#ids + 1] = idNum
                end
            end
            table.sort(ids)
            return ids
        end

        local function GetVisibleProfessionItemIDs()
            if not (_G.HousingItemList and _G.HousingItemList.GetFilteredItemIDs) then
                return {}
            end
            EnsureProfessionDataReady()
            local prof = _G.HousingProfessionData
            if type(prof) ~= "table" then
                return {}
            end
            local ids = {}
            for _, itemID in ipairs(_G.HousingItemList:GetFilteredItemIDs()) do
                local idNum = tonumber(itemID)
                if idNum and prof[idNum] then
                    ids[#ids + 1] = idNum
                end
            end
            return ids
        end

        local function Start(ids)
            if type(ids) ~= "table" or #ids == 0 then
                print("|cFF8A7FD4HousingVendor:|r No items to scan (" .. mode .. ").")
                return
            end

            local listenerKey = "HousingVendorAhScanCmd"
            HousingAuctionHouseAPI:UnregisterListener(listenerKey)

            local startedAt = time()
            local lastProgressPrint = 0
            local lastPrintedIndex = 0
            local baseCached = CountAuctionCache()

            HousingAuctionHouseAPI:RegisterListener(listenerKey, function(event, ...)
                if event == "scan_started" then
                    local total = select(1, ...)
                    print(string.format("|cFF8A7FD4HousingVendor:|r AH scan started (%s): %d items", mode, tonumber(total) or 0))
                    return
                end

                if event == "scan_progress" then
                    local index = tonumber(select(1, ...)) or 0
                    local total = tonumber(select(2, ...)) or 0
                    local itemID = tonumber(select(3, ...))
                    if debug or index == 1 or index == total or (index - lastPrintedIndex) >= 25 then
                        lastPrintedIndex = index
                        print(string.format("|cFF8A7FD4HousingVendor:|r AH scan %d/%d itemID=%s", index, total, tostring(itemID)))
                    else
                        local now = time()
                        if (now - lastProgressPrint) >= 2 then
                            lastProgressPrint = now
                            print(string.format("|cFF8A7FD4HousingVendor:|r AH scan %d/%d", index, total))
                        end
                    end
                    return
                end

                if event == "scan_timeout" then
                    local itemID = tonumber(select(1, ...))
                    print(string.format("|cFFFFD100HousingVendor:|r AH scan timeout (skipping): itemID=%s", tostring(itemID)))
                    return
                end

                if event == "price_updated" and debug then
                    local itemID = tonumber(select(1, ...))
                    local price = tonumber(select(2, ...))
                    if price and price > 0 then
                        print(string.format("|cFF8A7FD4HousingVendor:|r price_updated itemID=%s price=%d", tostring(itemID), price))
                    else
                        print(string.format("|cFF8A7FD4HousingVendor:|r price_updated itemID=%s (no price)", tostring(itemID)))
                    end
                    return
                end

                if event == "scan_complete" then
                    local total = tonumber(select(1, ...)) or 0
                    local elapsed = time() - startedAt
                    local cached = CountAuctionCache()
                    print(string.format("|cFF8A7FD4HousingVendor:|r AH scan complete: %d items in %ds (cached %d → %d)", total, elapsed, baseCached, cached))
                    HousingAuctionHouseAPI:UnregisterListener(listenerKey)
                    return
                end

                if event == "scan_stopped" then
                    local reason = tostring(select(1, ...))
                    print("|cFFFFD100HousingVendor:|r AH scan stopped: " .. reason)
                    HousingAuctionHouseAPI:UnregisterListener(listenerKey)
                    return
                end
            end)

            local maxAge = (HousingDB and HousingDB.settings and tonumber(HousingDB.settings.ahPriceMaxAgeSeconds)) or (6 * 60 * 60)
            local toScan = {}
            for _, id in ipairs(ids) do
                if force or HousingAuctionHouseAPI:IsPriceStale(id, maxAge) then
                    table.insert(toScan, id)
                end
            end

            if #toScan == 0 then
                print("|cFF8A7FD4HousingVendor:|r All items already have recent prices. Add `force` to rescan anyway.")
                HousingAuctionHouseAPI:UnregisterListener(listenerKey)
                return
            end

            HousingAuctionHouseAPI:QueueScan(toScan, force)
        end

        if HousingDataLoader and HousingDataLoader.EnsureDataLoaded then
            HousingDataLoader:EnsureDataLoaded(function()
                if mode == "all" then
                    Start(GetProfessionItemIDs())
                    return
                end

                local visible = GetVisibleProfessionItemIDs()
                if #visible == 0 then
                    print("|cFFFFD100HousingVendor:|r Visible scan requires the main UI item list and at least one profession item in your current filters. Use `/hv ahscan all` instead.")
                    return
                end
                Start(visible)
            end)
        else
            if mode == "all" then
                Start(GetProfessionItemIDs())
                return
            end

            local visible = GetVisibleProfessionItemIDs()
            if #visible == 0 then
                print("|cFFFFD100HousingVendor:|r Visible scan requires the main UI item list and at least one profession item in your current filters. Use `/hv ahscan all` instead.")
                return
            end
            Start(visible)
        end
        return
    elseif cmd == "mem" then
        if UpdateAddOnMemoryUsage then
            pcall(UpdateAddOnMemoryUsage)
        end
        local memKB = (GetAddOnMemoryUsage and GetAddOnMemoryUsage("HousingVendor")) or nil
        local memMB = memKB and (memKB / 1024) or nil
        print("|cFF8A7FD4HousingVendor:|r Memory: " .. (memMB and string.format("%.1f MB", memMB) or "n/a"))

        local sub = (args and args:lower()) or ""
        if sub == "gc" or sub == "collect" then
            if collectgarbage then
                collectgarbage("collect")
            end
            if UpdateAddOnMemoryUsage then
                pcall(UpdateAddOnMemoryUsage)
            end
            local afterKB = (GetAddOnMemoryUsage and GetAddOnMemoryUsage("HousingVendor")) or nil
            local afterMB = afterKB and (afterKB / 1024) or nil
            print("|cFF8A7FD4HousingVendor:|r After GC: " .. (afterMB and string.format("%.1f MB", afterMB) or "n/a"))
        end
    elseif cmd == "diag" then
        local apiDisabled = HousingDB and HousingDB.settings and HousingDB.settings.disableApiCalls
        local dm = _G.HousingDataManager
        local s = dm and dm._state or nil
        local uiActive = s and s.uiActive == true
        local batch = s and s.batchLoadInProgress == true
        local qualityLoading = s and s._qualityFilterLoading == true
        local costCount = 0
        local costComponentsCount = 0
        if _G.HousingCostData then
            for _, v in pairs(_G.HousingCostData) do
                costCount = costCount + 1
                if type(v) == "table" and type(v.costComponents) == "table" then
                    costComponentsCount = costComponentsCount + #v.costComponents
                end
            end
        end

        local apiCacheCount = 0
        if dm and dm.Util and dm.Util.GetApiDataCache then
            local t = dm.Util:GetApiDataCache()
            if type(t) == "table" then
                for _ in pairs(t) do apiCacheCount = apiCacheCount + 1 end
            end
        end

        local retryCount = 0
        if s and type(s._qualityRetryAt) == "table" then
            for _ in pairs(s._qualityRetryAt) do retryCount = retryCount + 1 end
        end

        print("|cFF8A7FD4HousingVendor:|r diag")
        print("  uiActive=" .. tostring(uiActive) .. " batchLoad=" .. tostring(batch) .. " qualityLoading=" .. tostring(qualityLoading))
        print("  apiDisabled=" .. tostring(apiDisabled) .. " apiCacheEntries=" .. tostring(apiCacheCount) .. " retryBackoff=" .. tostring(retryCount))
        print("  costDataEntries=" .. tostring(costCount) .. " costComponents=" .. tostring(costComponentsCount))
        if _G.HousingItemList and _G.HousingItemList.GetCostIconCacheStats then
            local st = _G.HousingItemList:GetCostIconCacheStats()
            print("  costIconCache=" .. tostring(st.entries) .. "/" .. tostring(st.max))
        end
        if HousingAPICache and HousingAPICache.IsCleanupTimerRunning then
            print("  apicacheCleanupTicker=" .. tostring(HousingAPICache:IsCleanupTimerRunning()))
        end
        if HousingDataEnhancer then
            print("  marketRefreshTicker=" .. tostring(HousingDataEnhancer.refreshTimer ~= nil))
        end
    elseif cmd == "stats" or cmd == "statistics" then
        if HousingCompletionTracker then
            local stats = HousingCompletionTracker:GetStatistics()
            print("|cFF8A7FD4HousingVendor Completion Statistics:|r")
            print("  Vendors visited: |cFFFFD100" .. stats.vendorsVisited .. "|r")
            print("  Achievements earned: |cFFFFD100" .. stats.achievementsEarned .. "|r")
            print("  Quests completed: |cFFFFD100" .. stats.questsCompleted .. "|r")
        else
            print("HousingVendor: CompletionTracker not available")
        end
    elseif cmd == "achievements" or cmd == "ach" then
        -- Scan and show housing achievements
        if HousingAchievementHandler then
            print("|cFF8A7FD4HousingVendor:|r Scanning housing achievements...")

            HousingAchievementHandler:ScanAllAchievements(function(success, error, scanned, completed)
                if success then
                    local stats = HousingAchievementHandler:GetStatistics()
                    print("|cFF00FF00Achievement scan complete!|r")
                    print("  Total achievements: |cFFFFD100" .. stats.total .. "|r")
                    print("  Completed: |cFF00FF00" .. stats.completed .. "|r")
                    print("  Remaining: |cFFFF4040" .. (stats.total - stats.completed) .. "|r")

                    if stats.byExpansion then
                        print("|cFF8A7FD4By Expansion:|r")
                        for expansion, data in pairs(stats.byExpansion) do
                            local percent = data.total > 0 and math.floor((data.completed / data.total) * 100) or 0
                            print("  " .. expansion .. ": |cFF00FF00" .. data.completed .. "|r/|cFFFFD100" .. data.total .. "|r (" .. percent .. "%)")
                        end
                    end
                else
                    print("|cFFFF4040Error scanning achievements:|r " .. tostring(error))
                end
            end)
        else
            print("|cFFFF4040HousingVendor:|r Achievement handler not available")
        end
        return
    elseif cmd == "scan" or cmd == "refresh" or cmd == "rescan" then
        -- Force scan all housing decor items via API (requires core data to be loaded).
        if HousingDataLoader then
            HousingDataLoader:EnsureDataLoaded(function()
                if HousingCollectionAPI then
                    print("|cFF8A7FD4HousingVendor:|r Starting collection scan...")
                    print("|cFF808080This may take a moment. Scanning in batches to avoid performance issues.|r")

                    HousingCollectionAPI:ScanAllDecorItems(function(success, scanned, collected, error)
                        if success then
                            local cacheStats = HousingCollectionAPI:GetCacheStats()
                            print("|cFF00FF00Scan complete!|r")
                            print("  Items scanned: |cFFFFD100" .. scanned .. "|r")
                            print("  Newly collected: |cFF00FF00" .. collected .. "|r")
                            print("  Total cached: |cFFFFD100" .. cacheStats.total .. "|r (|cFF808080" .. cacheStats.persistent .. " persistent, " .. cacheStats.session .. " session|r)")

                            -- Refresh UI if open
                            if HousingItemList and HousingItemList.RefreshCollectionStatus then
                                C_Timer.After(0.5, function()
                                    HousingItemList:RefreshCollectionStatus()
                                end)
                            end
                        else
                            print("|cFFFF0000Scan failed:|r " .. (error or "Unknown error"))
                        end
                    end)
                else
                    print("|cFFFF4040HousingVendor:|r HousingCollectionAPI not available")
                end
            end)
        else
            print("|cFFFF4040HousingVendor:|r DataLoader not available")
        end
    elseif cmd == "version" or cmd == "versioncheck" or cmd == "versionfilter" then
        if HousingVersionFilter then
            local info = HousingVersionFilter:GetCurrentGameVersion()
            local isBeta = HousingVersionFilter:IsBetaClient()
            local expansions = HousingVersionFilter:GetAvailableExpansions()

            print("|cFF8A7FD4HousingVendor Version Filter:|r")
            print("  Game Version: |cFFFFD100" .. (info.version or "Unknown") .. "|r")
            print("  Build: |cFFFFD100" .. (info.build or "Unknown") .. "|r")
            print("  TOC Version: |cFFFFD100" .. (info.tocVersion or "Unknown") .. "|r")
            print("  Client Type: " .. (isBeta and "|cFFFFD100Beta/PTR|r" or "|cFF00FF00Live|r"))
            print("  Available Expansions: |cFFFFD100" .. #expansions .. "|r")

            for _, expansion in ipairs(expansions) do
                print("    - " .. expansion)
            end

            if isBeta then
                print("  |cFFFFD100Midnight content is VISIBLE (Beta client detected)|r")
            else
            print("  |cFF808080Midnight content is HIDDEN (Live client detected)|r")
            end
        else
            print("|cFFFF4040HousingVendor:|r VersionFilter not available")
        end
    elseif cmd == "api" then
        local sub = (args and args:lower()) or ""
        if not HousingDB then HousingDB = {} end
        HousingDB.settings = HousingDB.settings or {}

        if sub == "off" or sub == "0" or sub == "false" then
            HousingDB.settings.disableApiCalls = true
            print("|cFF8A7FD4HousingVendor:|r API calls disabled (debug mode)")
        elseif sub == "on" or sub == "1" or sub == "true" then
            HousingDB.settings.disableApiCalls = false
            print("|cFF8A7FD4HousingVendor:|r API calls enabled")
        else
            local state = (HousingDB.settings.disableApiCalls and "OFF" or "ON")
            print("|cFF8A7FD4HousingVendor:|r API calls are currently " .. state .. ". Use `/hv api off` or `/hv api on`.")
        end
        return
    elseif cmd == "showall" then
        -- Toggle showing all items (including unreleased/PTR items)
        if HousingFilters and HousingFilters.ToggleShowAll then
            local showingOnlyLive = HousingFilters:ToggleShowAll()
            if _G.HousingCompactUI and _G.HousingCompactUI.SetShowOnlyAvailable then
                pcall(_G.HousingCompactUI.SetShowOnlyAvailable, _G.HousingCompactUI, showingOnlyLive)
            end
            if showingOnlyLive then
                print("|cFF8A7FD4HousingVendor:|r Now showing only |cFF00FF00LIVE|r items")
            else
                print("|cFF8A7FD4HousingVendor:|r Now showing |cFFFFD100ALL|r items (including PTR/unreleased)")
            end
        else
            print("|cFFFF4040HousingVendor:|r Filters module not available")
        end
        return
    elseif cmd == "mark" or cmd == "marker" then
        -- Show vendor marker UI
        if HousingVendorMarker and HousingVendorMarker.CreateMarkerFrame then
            if not (HousingDB and HousingDB.settings and HousingDB.settings.enableVendorMarker) then
                print("|cFFFF0000HousingVendor:|r Vendor marker is disabled. Enable it in settings (/hv config)")
            end

            -- Parse vendor name and NPC ID from args
            local vendorName = args and args ~= "" and args or "No vendor selected"
            local npcID = nil

            -- Try to get NPC ID from target
            if UnitExists("target") then
                local guid = UnitGUID("target")
                if guid then
                    local unitType, _, _, _, _, targetNPCID = strsplit("-", guid)
                    if unitType == "Creature" then
                        npcID = tonumber(targetNPCID)
                        vendorName = UnitName("target") or vendorName
                    end
                end
            end

            HousingVendorMarker:ShowForVendor(vendorName, npcID)
            if not npcID then
                print("|cFFFF0000HousingVendor:|r Target a vendor NPC for marking/distance.")
            end
        else
            print("|cFFFF4040HousingVendor:|r Vendor marker not available")
        end
        return
    elseif cmd == "debugnp" or cmd == "debugnameplate" then
        -- Debug nameplate structure
        if HousingVendorMarker then
            if args and args:lower() == "toggle" then
                HousingVendorMarker:ToggleDebug()
            else
                HousingVendorMarker:DebugCurrentNameplate()
            end
        else
            print("|cFFFF4040HousingVendor:|r Vendor marker not available")
        end
        return
    elseif cmd == "zone" then
        -- Manually trigger zone popup check
        if HousingOutstandingItemsUI and HousingOutstandingItemsUI.TogglePopup then
            local mapID, zoneName = HousingOutstandingItemsUI:GetCurrentZone()

            -- Debug output
            if args and args:lower() == "debug" then
                print("|cFF8A7FD4HousingVendor Zone Debug:|r")
                print("  Current MapID: " .. tostring(mapID or "nil"))
                print("  Current Zone Name: " .. tostring(zoneName or "nil"))
                if HousingOutstandingItemsUI.DebugZoneSummary then
                    HousingOutstandingItemsUI:DebugZoneSummary(mapID, zoneName)
                end
            end

            -- Force refresh collection data
            if HousingCollectionAPI and HousingCollectionAPI.ForceRefresh then
                pcall(HousingCollectionAPI.ForceRefresh, HousingCollectionAPI)
            end

            HousingOutstandingItemsUI:TogglePopup()
        else
            print("|cFFFF4040HousingVendor:|r OutstandingItemsUI module not available")
        end
        return
    elseif cmd == "cost" or cmd == "price" then
        -- Debug cost/price data for an item
        local itemID = tonumber(args)
        if not itemID then
            print("|cFFFF4040HousingVendor:|r Usage: /hv cost <itemID>")
            print("Example: /hv cost 253173")
            return
        end

        print("|cFF8A7FD4HousingVendor Cost Debug for Item " .. itemID .. ":|r")

        -- Check if API is disabled
        if HousingDB and HousingDB.settings and HousingDB.settings.disableApiCalls then
            print("|cFFFF4040  WARNING: API calls are disabled! Enable with /hv api on|r")
        end

        -- Get decorID first
        if HousingAPI and HousingAPI.GetDecorItemInfoFromItemID then
            local decorInfo = HousingAPI:GetDecorItemInfoFromItemID(itemID)
            if decorInfo and decorInfo.decorID then
                print("  DecorID: |cFFFFD100" .. decorInfo.decorID .. "|r")

                -- Get vendor info with cost
                if HousingAPI.GetDecorVendorInfo then
                    local vendorInfo = HousingAPI:GetDecorVendorInfo(decorInfo.decorID)
                    if vendorInfo then
                        print("  Vendor: |cFFFFD100" .. tostring(vendorInfo.name or "nil") .. "|r")
                        print("  Zone: |cFFFFD100" .. tostring(vendorInfo.zone or "nil") .. "|r")

                        if vendorInfo.cost and #vendorInfo.cost > 0 then
                            print("  Cost entries: |cFFFFD100" .. #vendorInfo.cost .. "|r")
                            for i, costEntry in ipairs(vendorInfo.cost) do
                                local desc = "Entry " .. i .. ": "
                                if costEntry.currencyID == 0 then
                                    desc = desc .. (costEntry.amount or 0) .. " copper (gold)"
                                elseif costEntry.currencyID then
                                    desc = desc .. (costEntry.amount or 0) .. " currency ID " .. costEntry.currencyID
                                elseif costEntry.itemID then
                                    desc = desc .. (costEntry.amount or 0) .. "x item ID " .. costEntry.itemID
                                end
                                print("    " .. desc)
                            end
                        else
                            print("  |cFFFF4040Cost: EMPTY (vendorInfo.cost is nil or empty)|r")
                        end
                    else
                        print("  |cFFFF4040GetDecorVendorInfo returned nil|r")
                    end
                end
            else
                print("  |cFFFF4040DecorID not found for this itemID|r")
            end
        end

        -- Check catalog data
        if HousingAPI and HousingAPI.GetCatalogData then
            local catalogData = HousingAPI:GetCatalogData(itemID)
            if catalogData then
                print("  Catalog cost: |cFFFFD100" .. tostring(catalogData.cost or "nil") .. "|r")
                print("  Catalog costRaw: |cFFFFD100" .. tostring(catalogData.costRaw or "nil") .. "|r")
                print("  Catalog vendor: |cFFFFD100" .. tostring(catalogData.vendor or "nil") .. "|r")
                print("  Catalog zone: |cFFFFD100" .. tostring(catalogData.zone or "nil") .. "|r")
            else
                print("  |cFFFF4040GetCatalogData returned nil|r")
            end
        end

        -- Check static data
        if HousingDataManager and HousingDataManager.GetItemRecord then
            local record = HousingDataManager:GetItemRecord(itemID)
            if record then
                print("  Static vendor: |cFFFFD100" .. tostring(record.vendorName or "nil") .. "|r")
                print("  Static zone: |cFFFFD100" .. tostring(record.zoneName or "nil") .. "|r")
                print("  Static cost: |cFFFFD100(not stored in static data)|r")
            else
                print("  |cFFFF4040No static data record found|r")
            end
        end

        return
    elseif cmd == "item" or cmd == "debugitem" then
        local itemID = tonumber(args)
        if not itemID then
            print("|cFFFF4040HousingVendor:|r Usage: /hv item <itemID>")
            print("Example: /hv item 245284")
            return
        end

        local function DumpItem()
            if UpdateAddOnMemoryUsage then
                pcall(UpdateAddOnMemoryUsage)
            end
            local memKB = (GetAddOnMemoryUsage and GetAddOnMemoryUsage("HousingVendor")) or nil
            local memMB = memKB and (memKB / 1024) or nil

            local itemName = (_G.C_Item and _G.C_Item.GetItemNameByID and _G.C_Item.GetItemNameByID(itemID)) or nil
            print("|cFF8A7FD4HousingVendor Item Debug:|r " .. itemID .. (itemName and (" - " .. tostring(itemName)) or ""))
            if memMB then
                print("  Addon Mem: " .. string.format("%.1f MB", memMB))
            end

            local isDNT = _G.HousingDNTItems and _G.HousingDNTItems[itemID] and true or false
            local isNotReleased = _G.HousingNotReleased and _G.HousingNotReleased[itemID] and true or false
            print("  DNT=" .. tostring(isDNT) .. " NotReleased=" .. tostring(isNotReleased))

            local record = (HousingDataManager and HousingDataManager.GetItemRecord) and HousingDataManager:GetItemRecord(itemID) or nil
            if not record then
                print("  |cFFFF4040No DataManager record found.|r")
                return
            end

            print("  name=" .. tostring(record.name))
            print("  sourceType=" .. tostring(record._sourceType) .. " expansion=" .. tostring(record.expansionName))
            print("  decorID=" .. tostring(record.decorID) .. " modelFileID=" .. tostring(record.modelFileID) .. " iconFileID=" .. tostring(record.thumbnailFileID))
            print("  vendor=" .. tostring(record.vendorName or record._apiVendor) .. " zone=" .. tostring(record.zoneName or record._apiZone))
            if record.mapID and record.coords then
                print("  mapID=" .. tostring(record.mapID) .. " coords=" .. string.format("%.1f,%.1f", tonumber(record.coords.x or 0) or 0, tonumber(record.coords.y or 0) or 0))
            end
            print("  questId=" .. tostring(record._questId) .. " achievementId=" .. tostring(record._achievementId) .. " profession=" .. tostring(record.profession))
            print("  cost=" .. tostring(record.cost) .. " buyPriceCopper=" .. tostring(record.buyPriceCopper))
            local comps = record._staticCostComponents
            print("  staticCostComponents=" .. tostring(type(comps) == "table" and #comps or 0))

            -- Collection status (best-effort debug, may be nil if APIs are gated)
            local collectedInfo = nil
            if HousingCollectionAPI and HousingCollectionAPI.GetCollectionInfo then
                collectedInfo = HousingCollectionAPI:GetCollectionInfo(itemID)
            end
            if collectedInfo then
                print("  collected=" .. tostring(collectedInfo.isCollected) ..
                    " numStored=" .. tostring(collectedInfo.numStored) ..
                    " numPlaced=" .. tostring(collectedInfo.numPlaced) ..
                    " totalOwned=" .. tostring(collectedInfo.totalOwned))
            else
                print("  collected=unknown (CollectionAPI not available)")
            end

            local expData = _G.HousingExpansionData and _G.HousingExpansionData[itemID] or nil
            if expData then
                local has = {}
                for k in pairs(expData) do has[#has + 1] = k end
                table.sort(has)
                print("  expansionDataKeys=" .. table.concat(has, ","))
            else
                print("  expansionDataKeys=nil")
            end
        end

        if HousingDataLoader and HousingDataLoader.EnsureDataLoaded then
            HousingDataLoader:EnsureDataLoaded(function()
                DumpItem()
            end)
        else
            DumpItem()
        end
        return
    elseif cmd == "mats" or cmd == "materials" then
        local ui = _G.HousingMaterialsTrackerUI
        if not (ui and (ui.Toggle or ui.ShowWishlist)) then
            print("|cFFFF4040HousingVendor:|r MaterialsTrackerUI module missing")
            return
        end

        local raw = (args and tostring(args)) or ""
        local lower = raw:lower()

        if lower == "" or lower == "toggle" then
            ui:Toggle()
            return
        end
        if lower == "wishlist" then
            ui:ShowWishlist()
            return
        end
        if lower == "raw" or lower == "rawmats" then
            if ui.ShowRawMats then
                ui:ShowRawMats()
            else
                ui:ShowWishlist()
            end
            return
        end

        local itemID = tonumber(raw)
        if itemID and ui.ShowForItem then
            ui:ShowForItem(itemID)
            return
        end

        ui:ShowWishlist()
        return
    else
        -- Load data addon and open UI
        if HousingDataLoader then
            HousingDataLoader:EnsureDataLoaded(function()
                local settings = HousingDB and HousingDB.settings or nil
                local preferCompact = settings and settings.simpleMode == true
                local compact = _G.HousingCompactUI or _G.HousingSimpleUI

                if preferCompact and compact and compact.Toggle then
                    compact:Toggle()
                    return
                end

                if HousingUINew and HousingUINew.Toggle then
                    HousingUINew:Toggle()
                    return
                end

                print("HousingVendor UI not available - modules may not be loaded")
            end)
        else
            print("HousingVendor DataLoader not available")
        end
    end
end
