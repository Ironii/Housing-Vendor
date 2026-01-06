-- Housing Vendor Items - Cataclysm (grouped vendor data)

local vendors = {
  [1] = {
    expansion = "Cataclysm",
    location = "Ruins of Gilneas",
    vendorName = "Marie Allen",
    npcID = "None",
    faction = 0,
    coords = {x = 60.4, y = 92.4, mapID = 217},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
  [2] = {
    expansion = "Cataclysm",
    location = "Thundermar, Twilight Highlands",
    vendorName = "Breana Bitterbrand",
    npcID = 253227,
    faction = 1,
    coords = {x = 49.6, y = 29.6, mapID = 241},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
  [3] = {
    expansion = "Cataclysm",
    location = "The Maelstrom",
    vendorName = "Flamesmith Lanying",
    npcID = "None",
    faction = 0,
    coords = {x = 30.32, y = 60.69, mapID = 726},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
  [4] = {
    expansion = "Cataclysm",
    location = "Thundermar, Twilight Highlands",
    vendorName = "Craw MacGraw",
    npcID = 49386,
    faction = 1,
    coords = {x = 48.6, y = 30.6, mapID = 241},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
  [5] = {
    expansion = "Cataclysm",
    location = "Ruins of Gilneas City",
    vendorName = "Samantha Buckley",
    npcID = "None",
    faction = 0,
    coords = {x = 61.99, y = 36.72, mapID = 218},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
}

local itemEntries = {
  { vendorId = 1, itemID = "245520", itemName = "Gilnean Celebration Keg" },
  { vendorId = 1, itemID = "245516", itemName = "Gilnean Bench" },
  { vendorId = 1, itemID = "245515", itemName = "Gilnean Wooden Bed" },
  { vendorId = 1, itemID = "245604", itemName = "Arched Rose Trellis" },
  { vendorId = 1, itemID = "245617", itemName = "Gilnean Stocks" },
  { vendorId = 2, itemID = "246427", itemName = "Dilapidated Wildhammer Well" },
  { vendorId = 2, itemID = "246428", itemName = "Overgrown Wildhammer Fountain" },
  { vendorId = 3, itemID = "250914", itemName = "Elemental Altar of the Maelstrom" },
  { vendorId = 3, itemID = "250916", itemName = "Pedestal of the Maelstrom's Wisdom" },
  { vendorId = 3, itemID = "250918", itemName = "Maelstrom Banner" },
  { vendorId = 3, itemID = "251014", itemName = "Earthen Ring Scouting Map" },
  { vendorId = 3, itemID = "251015", itemName = "Maelstrom Chimes" },
  { vendorId = 3, itemID = "257403", itemName = "Maelstrom Lava Lamp" },
  { vendorId = 1, itemID = "258301", itemName = "Gilnean Washing Line" },
  { vendorId = 2, itemID = "246108", itemName = "Embellished Dwarven Tome" },
  { vendorId = 2, itemID = "246425", itemName = "Round Dwarven Table" },
  { vendorId = 4, itemID = "246108", itemName = "Embellished Dwarven Tome" },
  { vendorId = 4, itemID = "246425", itemName = "Round Dwarven Table" },
  { vendorId = 5, itemID = "245516", itemName = "Gilnean Bench" },
  { vendorId = 5, itemID = "245617", itemName = "Gilnean Stocks" },
  { vendorId = 5, itemID = "258301", itemName = "Gilnean Washing Line" },
  { vendorId = 5, itemID = "245520", itemName = "Gilnean Celebration Keg" },
  { vendorId = 5, itemID = "245604", itemName = "Arched Rose Trellis" },
  { vendorId = 5, itemID = "245515", itemName = "Gilnean Wooden Bed" },
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
