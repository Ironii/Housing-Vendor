
local _G = _G
local OutstandingItemsUI = _G["HousingOutstandingItemsUI"]
if not OutstandingItemsUI then return end

local function NormalizeFaction(value)
    if value == nil then
        return nil
    end
    if type(value) == "number" then
        if value == 1 then
            return "Alliance"
        elseif value == 2 then
            return "Horde"
        elseif value == 0 then
            return "Neutral"
        end
    end
    return value
end

local function VendorMatchesPlayerFaction(vendor)
    if not vendor then
        return true
    end
    local vendorFaction = NormalizeFaction(vendor.faction)
    if not vendorFaction or vendorFaction == "" or vendorFaction == "None" then
        return true
    end
    if vendorFaction == "Neutral" then
        return true
    end
    local playerFaction = UnitFactionGroup("player")
    return vendorFaction == playerFaction
end

local function GetBestZoneMapID()
    if not (C_Map and C_Map.GetBestMapForUnit) then
        return nil
    end

    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then
        return nil
    end

    -- Refine to a child zone mapID when the best map is a parent.
    if C_Map.GetPlayerMapPosition and C_Map.GetMapInfoAtPosition then
        local pos = C_Map.GetPlayerMapPosition(mapID, "player")
        if pos and pos.x and pos.y and not (pos.x == 0 and pos.y == 0) then
            local ok, mapInfo = pcall(function()
                return C_Map.GetMapInfoAtPosition(mapID, pos)
            end)
            if ok and mapInfo and mapInfo.mapID then
                mapID = mapInfo.mapID
            end
        end
    end

    return mapID
end

function OutstandingItemsUI:GetCurrentZone()
    local mapID = GetBestZoneMapID()
    if mapID and C_Map and C_Map.GetMapInfo then
        local mapInfo = C_Map.GetMapInfo(mapID)
        if mapInfo and mapInfo.name and mapInfo.name ~= "" then
            return mapID, mapInfo.name
        end
    end

    local fallbackName = _G.GetRealZoneText and _G.GetRealZoneText() or nil
    if fallbackName and fallbackName ~= "" then
        return nil, fallbackName
    end

    return nil, nil
end

function OutstandingItemsUI:GetOutstandingItemsForZone(mapID, zoneName)
    if (not mapID and not zoneName) or not HousingDataManager then
        return nil
    end

    local ids = nil
    if HousingDataManager.GetAllItemIDs then
        ids = HousingDataManager:GetAllItemIDs()
    end
    if not ids or #ids == 0 then
        if HousingDataManager.GetAllItems then
            local allItems = HousingDataManager:GetAllItems()
            ids = {}
            for _, item in ipairs(allItems or {}) do
                local idNum = item and tonumber(item.itemID)
                if idNum then
                    ids[#ids + 1] = idNum
                end
            end
        end
    end
    if not ids or #ids == 0 then
        return nil
    end

    local outstanding = {
        total = 0,
        vendors = {},
        quests = {},
        achievements = {},
        drops = {},
        professions = {},
    }

    local function IsCollected(itemID)
        -- Avoid placed-decor scans in popup context to prevent taint.
        if HousingCollectionAPI and HousingCollectionAPI.IsItemCollectedViaHousingAPI then
            return HousingCollectionAPI:IsItemCollectedViaHousingAPI(itemID)
        end
        if HousingCollectionAPI and HousingCollectionAPI.IsItemCollected then
            return HousingCollectionAPI:IsItemCollected(itemID)
        end
        -- Fallback to DataManager
        if HousingDataManager and HousingDataManager.IsItemCollected then
            return HousingDataManager:IsItemCollected(itemID)
        end
        -- Fallback to CompletionTracker
        if HousingCompletionTracker and HousingCompletionTracker.IsCollected then
            return HousingCompletionTracker:IsCollected(itemID)
        end
        return false
    end

    for _, idNum in ipairs(ids) do
        local record = HousingDataManager.GetItemRecord and HousingDataManager:GetItemRecord(idNum) or nil
        if record then
            -- Get vendor's actual zone and coords using VendorHelper for accuracy
            local recordZone = nil
            local vendorMapID = nil
            local matchedVendor = nil

            if mapID and record._vendorIndices and _G.HousingVendorPool then
                for _, idx in ipairs(record._vendorIndices) do
                    local v = _G.HousingVendorPool[idx]
                    if v and v.coords and v.coords.mapID and v.coords.mapID == mapID and VendorMatchesPlayerFaction(v) then
                        matchedVendor = v
                        vendorMapID = v.coords.mapID
                        recordZone = v.location
                        break
                    end
                end
            end

            if _G.HousingVendorHelper and not matchedVendor then
                recordZone = _G.HousingVendorHelper.GetZoneName and _G.HousingVendorHelper:GetZoneName(record, nil, mapID)
                local vendorCoords = _G.HousingVendorHelper.GetVendorCoords and _G.HousingVendorHelper:GetVendorCoords(record, nil, nil, mapID)
                if vendorCoords and vendorCoords.mapID then
                    vendorMapID = vendorCoords.mapID
                end
            end

            -- Fallback if VendorHelper unavailable
            -- Prefer _apiZone (localized) over zoneName (English) for zone matching
            if not recordZone then
                recordZone = record._apiZone or record.zoneName
            end
            if not vendorMapID then
                vendorMapID = record.mapID
            end

            local matchesZone = false
            -- Prioritize mapID matching for accuracy (prevents cross-zone pollution)
            if mapID and vendorMapID and vendorMapID ~= 0 then
                -- Only match if mapIDs are exactly the same
                if vendorMapID == mapID then
                    matchesZone = true
                end
            elseif zoneName and recordZone then
                -- Fallback to zone name matching when:
                -- 1. Player mapID unavailable, OR
                -- 2. Vendor mapID unavailable/zero (legacy data)
                -- Note: This will fail with non-English clients if data is English,
                -- but it's better than showing nothing for legacy items without mapID
                if recordZone == zoneName then
                    matchesZone = true
                end
            end

            if matchesZone then
                local itemID = tonumber(record.itemID) or idNum
                local isItemCollected = IsCollected(itemID)

                -- For quest/achievement items, also check if they're complete
                local isQuestComplete = false
                local isAchievementComplete = false
                local src = record._sourceType or record.sourceType or "Vendor"

                if src == "Quest" then
                    local questID = record._questId or record.questRequired
                    if questID then
                        local numericQuestID = tonumber(questID)
                        -- If questID is text, try to extract numeric ID
                        if not numericQuestID and type(questID) == "string" then
                            numericQuestID = tonumber(string.match(questID, "%d+"))
                        end
                        if numericQuestID and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
                            isQuestComplete = C_QuestLog.IsQuestFlaggedCompleted(numericQuestID)
                        end
                    end
                elseif src == "Achievement" then
                    local achievementID = record._achievementId or record.achievementRequired
                    if achievementID then
                        local numericAchievementID = tonumber(achievementID)
                        -- If achievementID is text, try to extract numeric ID
                        if not numericAchievementID and type(achievementID) == "string" then
                            numericAchievementID = tonumber(string.match(achievementID, "%d+"))
                        end
                        if numericAchievementID and C_AchievementInfo and C_AchievementInfo.GetAchievementInfo then
                            local achievementInfo = C_AchievementInfo.GetAchievementInfo(numericAchievementID)
                            if achievementInfo then
                                isAchievementComplete = achievementInfo.completed or false
                            end
                        end
                    end
                end

                -- Item is outstanding if it's not collected AND (if quest/achievement) not yet completed
                local isOutstanding = not isItemCollected
                if src == "Quest" and isQuestComplete then
                    isOutstanding = false  -- Quest is complete, item is obtainable
                elseif src == "Achievement" and isAchievementComplete then
                    isOutstanding = false  -- Achievement is complete, item is obtainable
                end

                if isOutstanding then
                    outstanding.total = outstanding.total + 1

                    -- Categorize by source type (use _sourceType as authoritative)
                    if src == "Quest" then
                        table.insert(outstanding.quests, record)
                    elseif src == "Achievement" then
                        table.insert(outstanding.achievements, record)
                    elseif src == "Drop" then
                        table.insert(outstanding.drops, record)
                    elseif src == "Profession" then
                        table.insert(outstanding.professions, record)
                    else
                        -- Default to Vendor (includes items with _sourceType = "Vendor" or no _sourceType)
                        local vendorName = nil
                        local vendorCoords = nil
                        if matchedVendor then
                            vendorName = matchedVendor.name
                            vendorCoords = matchedVendor.coords
                        elseif _G.HousingVendorHelper then
                            vendorName = _G.HousingVendorHelper:GetVendorName(record, nil, nil, mapID)
                            vendorCoords = _G.HousingVendorHelper:GetVendorCoords(record, nil, nil, mapID)
                        else
                            vendorName = record.vendorName or record._apiVendor
                            vendorCoords = record.vendorCoords
                        end

                        if vendorName and vendorName ~= "" then
                            local vendorKey = vendorName
                            if vendorMapID and vendorMapID ~= 0 then
                                vendorKey = vendorName .. "@" .. tostring(vendorMapID)
                            elseif record.npcID then
                                vendorKey = vendorName .. "#npc" .. tostring(record.npcID)
                            end
                            local displayName = vendorName
                            if recordZone and recordZone ~= "" then
                                displayName = vendorName .. " (" .. recordZone .. ")"
                            end
                            local entry = outstanding.vendors[vendorKey]
                            if not entry then
                                entry = { name = displayName, baseName = vendorName, coords = vendorCoords, mapID = vendorMapID, npcID = record.npcID, items = {} }
                                outstanding.vendors[vendorKey] = entry
                            end
                            table.insert(entry.items, record)
                        end
                    end
                end
            end
        end
    end

    return outstanding
end

function OutstandingItemsUI:DebugZoneSummary(mapID, zoneName, sampleLimit)
    if (not mapID and not zoneName) or not HousingDataManager then
        print("|cFFFF4040HousingVendor:|r Zone debug: missing mapID/zone or DataManager")
        return
    end

    local ids = nil
    if HousingDataManager.GetAllItemIDs then
        ids = HousingDataManager:GetAllItemIDs()
    end
    if not ids or #ids == 0 then
        print("|cFFFF4040HousingVendor:|r Zone debug: no item IDs available")
        return
    end

    local function IsCollected(itemID)
        if HousingCollectionAPI and HousingCollectionAPI.IsItemCollected then
            return HousingCollectionAPI:IsItemCollected(itemID)
        end
        if HousingDataManager and HousingDataManager.IsItemCollected then
            return HousingDataManager:IsItemCollected(itemID)
        end
        return false
    end

    local total = 0
    local matchedZone = 0
    local collected = 0
    local outstanding = 0
    local sample = {}
    local limit = tonumber(sampleLimit) or 5

    for _, idNum in ipairs(ids) do
        total = total + 1
        local record = HousingDataManager.GetItemRecord and HousingDataManager:GetItemRecord(idNum) or nil
        if record then
            local recordZone = nil
            local vendorMapID = nil
            local matchedVendor = nil

            if mapID and record._vendorIndices and _G.HousingVendorPool then
                for _, idx in ipairs(record._vendorIndices) do
                    local v = _G.HousingVendorPool[idx]
                    if v and v.coords and v.coords.mapID and v.coords.mapID == mapID and VendorMatchesPlayerFaction(v) then
                        matchedVendor = v
                        vendorMapID = v.coords.mapID
                        recordZone = v.location
                        break
                    end
                end
            end

            if _G.HousingVendorHelper and not matchedVendor then
                recordZone = _G.HousingVendorHelper.GetZoneName and _G.HousingVendorHelper:GetZoneName(record, nil, mapID)
                local vendorCoords = _G.HousingVendorHelper.GetVendorCoords and _G.HousingVendorHelper:GetVendorCoords(record, nil, nil, mapID)
                if vendorCoords and vendorCoords.mapID then
                    vendorMapID = vendorCoords.mapID
                end
            end

            if not recordZone then
                recordZone = record._apiZone or record.zoneName
            end
            if not vendorMapID then
                vendorMapID = record.mapID
            end

            local matchesZone = false
            if mapID and vendorMapID and vendorMapID ~= 0 then
                if vendorMapID == mapID then
                    matchesZone = true
                end
            elseif zoneName and recordZone then
                if recordZone == zoneName then
                    matchesZone = true
                end
            end

            if matchesZone then
                matchedZone = matchedZone + 1
                local itemID = tonumber(record.itemID) or idNum
                local isCollected = IsCollected(itemID)
                if isCollected then
                    collected = collected + 1
                else
                    outstanding = outstanding + 1
                end

                if #sample < limit then
                    local vendorName = nil
                    if matchedVendor then
                        vendorName = matchedVendor.name
                    elseif _G.HousingVendorHelper then
                        vendorName = _G.HousingVendorHelper:GetVendorName(record, nil, nil, mapID)
                    else
                        vendorName = record.vendorName or record._apiVendor
                    end
                    sample[#sample + 1] = {
                        itemID = itemID,
                        vendor = vendorName or "Unknown",
                        mapID = vendorMapID or 0,
                        zone = recordZone or "Unknown",
                        collected = isCollected and "yes" or "no",
                    }
                end
            end
        end
    end

    print(string.format("|cFF8A7FD4HousingVendor Zone Debug:|r total=%d matched=%d outstanding=%d collected=%d",
        total, matchedZone, outstanding, collected))
    for _, s in ipairs(sample) do
        print(string.format("  item=%s vendor=%s mapID=%s zone=%s collected=%s",
            tostring(s.itemID), tostring(s.vendor), tostring(s.mapID), tostring(s.zone), tostring(s.collected)))
    end
end

return OutstandingItemsUI
