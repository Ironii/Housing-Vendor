-- Housing Vendor Items - WrathoftheLichKing (grouped vendor data)

local vendors = {
  [1] = {
    expansion = "Wrath of the Lich King",
    location = "Grizzly Hills",
    vendorName = "Woodsman Drake",
    npcID = 27391,
    faction = 1,
    coords = {x = 32.4, y = 59.8, mapID = 116},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
  [2] = {
    expansion = "Wrath of the Lich King",
    location = "Nesingwary Base Camp",
    vendorName = "Purser Boulian",
    npcID = 28038,
    faction = 0,
    coords = {x = 26.8, y = 59.2, mapID = 119},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
  [3] = {
    expansion = "Wrath of the Lich King",
    location = "Borean Tundra",
    vendorName = "Ahlurglgr",
    npcID = 25206,
    faction = 0,
    coords = {x = 43.04, y = 13.81, mapID = 114},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [4] = {
    expansion = "Wrath of the Lich King",
    location = "Sholazar Basin",
    vendorName = "Purser Boulian",
    npcID = 61911,
    faction = 0,
    coords = {x = 26.8, y = 59.2, mapID = 119},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [5] = {
    expansion = "Wrath of the Lich King",
    location = "Sholazar Basin",
    vendorName = "Purser Boulian",
    npcID = 72111,
    faction = 0,
    coords = {x = 26.8, y = 59.2, mapID = 119},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [6] = {
    expansion = "Wrath of the Lich King",
    location = "Sholazar Basin",
    vendorName = "Purser Boulian",
    npcID = 28038,
    faction = 0,
    coords = {x = 26.8, y = 59.2, mapID = 119},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
}

local itemEntries = {
  { vendorId = 1, itemID = "248622", itemName = "Wooden Outhouse" },
  { vendorId = 2, itemID = "248807", itemName = "Nesingwary Mounted Shoveltusk Head" },
  { vendorId = 3, itemID = "258220", itemName = "Murloc Driftwood Hut" },
  { vendorId = 4, itemID = "248807", itemName = "Nesingwary Mounted Shoveltusk Head" },
  { vendorId = 5, itemID = "248807", itemName = "Nesingwary Mounted Shoveltusk Head" },
  { vendorId = 6, itemID = "248807", itemName = "Nesingwary Mounted Shoveltusk Head" },
}

local items = {}
for index, entry in ipairs(itemEntries) do
  local vendor = vendors[entry.vendorId]
  if vendor then
    items[index] = {
      itemID = entry.itemID,
      itemName = entry.itemName,
      vendorDetails = vendor,
    }
  end
end

HousingDataAggregator_RegisterExpansionItems("vendor", items)
