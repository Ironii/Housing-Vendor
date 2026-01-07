-- Version Filter for Housing Vendor
-- Automatically hides items not available in the current game version
-- Shows beta content (e.g., Midnight expansion) only when logged into beta client

local HousingVersionFilter = {}

-- Version detection using WoW API
function HousingVersionFilter:GetCurrentGameVersion()
    local version, build, date, tocVersion = GetBuildInfo()

    -- Store version info
    self.versionInfo = {
        version = version,
        build = tonumber(build) or 0,
        date = date,
        tocVersion = tonumber(tocVersion) or 0
    }

    return self.versionInfo
end

-- Determine if we're on a beta/PTR client
function HousingVersionFilter:IsBetaClient()
    if not self.versionInfo then
        self:GetCurrentGameVersion()
    end

    -- Prefer Blizzard build flags when available.
    -- NOTE: Expansion-major version (e.g., 12.0 prepatch) does NOT necessarily mean beta/PTR.
    if _G.IsTestBuild and type(_G.IsTestBuild) == "function" then
        local ok, isTest = pcall(_G.IsTestBuild)
        if ok and isTest then return true end
    end
    if _G.IsBetaBuild and type(_G.IsBetaBuild) == "function" then
        local ok, isBeta = pcall(_G.IsBetaBuild)
        if ok and isBeta then return true end
    end
    if _G.C_GameEnvironmentManager and _G.C_GameEnvironmentManager.IsOnPublicTestRealm then
        local ok, isPtr = pcall(_G.C_GameEnvironmentManager.IsOnPublicTestRealm)
        if ok and isPtr then return true end
    end

    -- Fallback heuristic: only treat very-high major versions as beta (safety net).
    local version = self.versionInfo.version or ""
    local versionNumber = tonumber(version:match("^(%d+)%.")) or 0
    return versionNumber >= 99
end

-- Get available expansions for current client
function HousingVersionFilter:GetAvailableExpansions()
    local isBeta = self:IsBetaClient()

    local expansions = {
        "Classic",
        "The Burning Crusade",
        "Wrath of the Lich King",
        "Cataclysm",
        "Mists of Pandaria",
        "Warlords of Draenor",
        "Legion",
        "Battle for Azeroth",
        "Shadowlands",
        "Dragonflight",
        "The War Within"
    }

    -- Add Midnight only if on beta client
    if isBeta then
        table.insert(expansions, "Midnight")
    end

    return expansions
end

-- Check if an expansion should be shown
function HousingVersionFilter:ShouldShowExpansion(expansionName)
    local availableExpansions = self:GetAvailableExpansions()

    for _, expansion in ipairs(availableExpansions) do
        if expansion == expansionName then
            return true
        end
    end

    return false
end

-- Filter vendor data by available expansions
function HousingVersionFilter:FilterVendorLocations(vendorLocations)
    if not vendorLocations then
        return {}
    end

    local filtered = {}

    for expansion, zones in pairs(vendorLocations) do
        if self:ShouldShowExpansion(expansion) then
            filtered[expansion] = zones
        end
    end

    return filtered
end

-- Filter items by checking if they're from available expansions
-- This works with the DataManager to hide unavailable items
function HousingVersionFilter:FilterItems(items)
    if not items or not HousingVendorLocations then
        return items
    end

    local availableExpansions = self:GetAvailableExpansions()
    local availableItemIDs = {}

    -- Build set of available item IDs from vendor locations
    for expansion, zones in pairs(HousingVendorLocations) do
        if self:ShouldShowExpansion(expansion) then
            for zoneName, vendors in pairs(zones) do
                for _, vendor in ipairs(vendors) do
                    if vendor.items then
                        for _, item in ipairs(vendor.items) do
                            if item.itemID then
                                availableItemIDs[item.itemID] = true
                            end
                        end
                    end
                end
            end
        end
    end

    -- Filter items list
    local filtered = {}
    for _, item in ipairs(items) do
        local itemID = item.itemID or item.id
        -- If item is in available expansions OR not from vendor data (e.g., professions, drops)
        -- then include it
        if availableItemIDs[itemID] or not item.expansion then
            table.insert(filtered, item)
        elseif item.expansion and self:ShouldShowExpansion(item.expansion) then
            table.insert(filtered, item)
        end
    end

    return filtered
end

-- Initialize and print version info (optional, for debugging)
function HousingVersionFilter:Initialize()
    self:GetCurrentGameVersion()

    -- Optional: Print version info to chat (comment out for production)
    if HousingDB and HousingDB.debug then
        local isBeta = self:IsBetaClient()
        print("|cFF8A7FD4HousingVendor:|r Version Filter Initialized")
        print("  Game Version: " .. (self.versionInfo.version or "Unknown"))
        print("  Build: " .. (self.versionInfo.build or "Unknown"))
        print("  Client Type: " .. (isBeta and "|cFFFFD100Beta/PTR|r" or "|cFF00FF00Live|r"))

        local expansions = self:GetAvailableExpansions()
        print("  Available Expansions: " .. #expansions)

        if isBeta then
            print("  |cFFFFD100Midnight content is visible (Beta client detected)|r")
        else
            print("  |cFF808080Midnight content is hidden (Live client detected)|r")
        end
    end
end

-- Make globally available
_G.HousingVersionFilter = HousingVersionFilter
