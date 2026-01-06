-- VendorHelper.lua
-- Utility functions for faction-aware vendor selection
-- Ensures all UI components show the correct vendor based on player faction

local VendorHelper = {}

local function GetVendorList(item)
    if not item or type(item) ~= "table" then
        return nil
    end

    -- Legacy: full vendor objects array
    if item._vendorData and type(item._vendorData) == "table" and #item._vendorData > 0 then
        return item._vendorData
    end

    -- Current: shared vendor pool + indices (memory-optimized)
    local pool = item._vendorPool or _G.HousingVendorPool
    if pool and type(pool) == "table"
        and item._vendorIndices and type(item._vendorIndices) == "table" and #item._vendorIndices > 0 then
        local out = {}
        for _, idx in ipairs(item._vendorIndices) do
            local v = idx and pool[idx] or nil
            if v and v.name and v.name ~= "" and v.name ~= "None" then
                table.insert(out, v)
            end
        end
        if #out > 0 then
            return out
        end
    end

    return nil
end

local function NormalizeZoneFilter(filterZone, filterMapID)
    if filterZone == "All Zones" then
        filterZone = nil
    end
    if filterMapID ~= nil then
        local num = tonumber(filterMapID)
        if not num or num == 0 then
            filterMapID = nil
        else
            filterMapID = num
        end
    end
    return filterZone, filterMapID
end

--- Selects the best vendor for an item based on player faction
--- @param item table The item record with _vendorData field
--- @param filterVendor string|nil Optional vendor filter (if user filtered by specific vendor)
--- @param filterZone string|nil Optional zone filter (if user filtered by specific zone)
--- @param filterMapID number|nil Optional zone mapID filter (preferred over zone name)
--- @return table|nil selectedVendor {name, location, coords, faction, expansion}
function VendorHelper:SelectVendorForItem(item, filterVendor, filterZone, filterMapID)
    local vendors = GetVendorList(item)

    -- If user has filtered by vendor, always show that vendor
    if filterVendor and filterVendor ~= "All Vendors" then
        if vendors then
            for _, vendorInfo in ipairs(vendors) do
                if vendorInfo and vendorInfo.name == filterVendor then
                    return vendorInfo
                end
            end
        end
        -- If filtered vendor not found in _vendorData, return basic info
        return {name = filterVendor}
    end

    filterZone, filterMapID = NormalizeZoneFilter(filterZone, filterMapID)
    if vendors and (filterZone or filterMapID) then
        local zoneMatches = {}
        for _, vendorInfo in ipairs(vendors) do
            local mapID = vendorInfo.coords and tonumber(vendorInfo.coords.mapID) or nil
            local location = vendorInfo.location
            if (filterMapID and mapID == filterMapID) or (filterZone and location == filterZone) then
                table.insert(zoneMatches, vendorInfo)
            end
        end
        if #zoneMatches > 0 then
            vendors = zoneMatches
        end
    end

    -- Use faction-aware vendor lookup
    if vendors and #vendors > 0 then
        local playerFaction = UnitFactionGroup("player")  -- Returns "Alliance" or "Horde"
        local factionMatch = nil
        local neutralMatch = nil
        local firstMatch = nil

        for _, vendorInfo in ipairs(vendors) do
            if vendorInfo.name and vendorInfo.name ~= "None" and vendorInfo.name ~= "" then
                -- Store first vendor as ultimate fallback
                if not firstMatch then
                    firstMatch = vendorInfo
                end

                -- Check faction match
                if vendorInfo.faction == playerFaction then
                    factionMatch = vendorInfo
                    break  -- Perfect match, stop searching
                elseif vendorInfo.faction == "Neutral" and not neutralMatch then
                    neutralMatch = vendorInfo
                end
            end
        end

        -- Priority: faction match > neutral > first vendor found
        return factionMatch or neutralMatch or firstMatch
    end

    return nil
end

--- Gets the best vendor name for display
--- Falls back through: filtered vendor -> faction vendor -> API vendor -> static vendor
--- @param item table The item record
--- @param filterVendor string|nil Optional vendor filter
--- @param filterZone string|nil Optional zone filter
--- @param filterMapID number|nil Optional zone mapID filter
--- @return string|nil vendorName
function VendorHelper:GetVendorName(item, filterVendor, filterZone, filterMapID)
    local selectedVendor = self:SelectVendorForItem(item, filterVendor, filterZone, filterMapID)
    if selectedVendor and selectedVendor.name then
        return selectedVendor.name
    end

    -- Fallback to static vendor data (authoritative) then API data
    -- Our hardcoded data is more accurate than Blizzard's API for vendor corrections
    return item.vendorName or item._apiVendor
end

--- Gets the best zone name for display
--- @param item table The item record
--- @param filterZone string|nil Optional zone filter
--- @param filterMapID number|nil Optional zone mapID filter
--- @return string|nil zoneName
function VendorHelper:GetZoneName(item, filterZone, filterMapID)
    -- If user has filtered by zone, show that zone
    if filterZone and filterZone ~= "All Zones" then
        return filterZone
    end

    -- Try to get zone from selected vendor
    local selectedVendor = self:SelectVendorForItem(item, nil, filterZone, filterMapID)
    if selectedVendor and selectedVendor.location then
        return selectedVendor.location
    end

    -- Fallback: Prefer API data (localized) for zone matching, then static data
    -- API data will match player's client language; static data is authoritative but English-only
    return item._apiZone or item.zoneName
end

--- Gets coordinates and mapID from the best vendor
--- @param item table The item record
--- @param filterVendor string|nil Optional vendor filter
--- @param filterZone string|nil Optional zone filter
--- @param filterMapID number|nil Optional zone mapID filter
--- @return table|nil coords {x, y, mapID}
function VendorHelper:GetVendorCoords(item, filterVendor, filterZone, filterMapID)
    local selectedVendor = self:SelectVendorForItem(item, filterVendor, filterZone, filterMapID)
    if selectedVendor and selectedVendor.coords then
        return selectedVendor.coords
    end

    -- Fallback to item coords
    return item.coords or item.vendorCoords
end

-- Make globally available
_G.HousingVendorHelper = VendorHelper
return VendorHelper
