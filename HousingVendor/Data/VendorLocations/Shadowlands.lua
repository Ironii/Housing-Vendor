-- Housing Vendor Items - Shadowlands (grouped vendor data)

local vendors = {
  [1] = {
    expansion = "Shadowlands",
    location = "The Maw",
    vendorName = "Ve'nari",
    npcID = 82159,
    faction = 0,
    coords = {x = 46.8, y = 41.6, mapID = 1543},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [2] = {
    expansion = "Shadowlands",
    location = "The Maw",
    vendorName = "Ve'nari",
    npcID = 177774,
    faction = 0,
    coords = {x = 46.8, y = 41.6, mapID = 1543},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [3] = {
    expansion = "Shadowlands",
    location = "The Maw",
    vendorName = "Ve'nari",
    npcID = 162804,
    faction = 0,
    coords = {x = 46.8, y = 41.6, mapID = 1543},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [4] = {
    expansion = "Shadowlands",
    location = "Bastion",
    vendorName = "Chachi the Artiste",
    npcID = 179482,
    faction = 0,
    coords = {x = 54.0, y = 24.8, mapID = 1533},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
  [5] = {
    expansion = "Shadowlands",
    location = "Sinfall",
    vendorName = "Chachi the Artiste",
    npcID = 174710,
    faction = 0,
    coords = {x = 54.0, y = 24.8, mapID = 1699},
    factionID = nil,
    factionName = nil,
    reputation = nil,
    extra = nil,
  },
}

local itemEntries = {
  { vendorId = 1, itemID = "248125", itemName = "Portal to Damnation" },
  { vendorId = 2, itemID = "248125", itemName = "Portal to Damnation" },
  { vendorId = 3, itemID = "248125", itemName = "Portal to Damnation" },
  { vendorId = 4, itemID = "245501", itemName = "Venthyr Tome of Unforgiven Sins" },
  { vendorId = 5, itemID = "245501", itemName = "Venthyr Tome of Unforgiven Sins" },
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
