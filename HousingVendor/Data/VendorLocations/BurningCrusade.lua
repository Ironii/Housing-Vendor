-- Housing Vendor Items - BurningCrusade (grouped vendor data)

local vendors = {
  [1] = {
    expansion = "Burning Crusade",
    location = "Tranquillien - Pre Midnight",
    vendorName = "Provisioner Vredigar",
    npcID = 16528,
    faction = 2,
    coords = {x = 47.6, y = 32.4, mapID = 95},
    factionID = "None",
    factionName = "None",
    reputation = "None",
    extra = "None",
  },
}

local itemEntries = {
  { vendorId = 1, itemID = "256049", itemName = "Sin'dorei Sleeper" },
  { vendorId = 1, itemID = "257419", itemName = "Sin'dorei Crafter's Forge" },
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
