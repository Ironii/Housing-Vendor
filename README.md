Description
HousingVendor  (v05.01.26.03)

Browse, track, and plan your housing decoration collection.
Key Features

    Complete housing database covering all expansions
    Modern UI with multiple themes and customizable settings
    Advanced search & filtering (expansion, vendor, zone, type, category, source, etc.)
    Collection tracking with ownership indicators (stored/placed)
    Statistics dashboard with progress breakdowns
    Waypoint navigation to vendor locations
    Multi-language support (11 languages)

Panels

    Main Browser: Filterable item list with preview panel
    Statistics: Collection progress breakdowns
    Achievements: Housing-related achievement tracking
    Reputation: Reputation/renown requirements tracking across characters
    Auction House (requires Auctionator or TSM):
        Cache and display AH prices for profession-crafted decor
        Preview panel shows Current AH Price (cached) with last-updated tooltip
        Item list shows cached AH price on profession items (updates live during scans)

Profession & Requirements

    Profession reagent requirements for crafted items with quantities
    Quest and achievement requirements with tooltips
    Reputation/renown requirements with progress indicators

Color Coding

    Red = Horde items
    Blue = Alliance items
    Gold = Achievement items
    Bright Blue = Quest items
    Orange/Red = Drop items
    Green = Vendor items
    Gray = Neutral items

Commands
General

    /hv (or /housingvendor) — Toggle the main UI
    /hv help — Show command list
    /hv version — Show addon version
    /hv showall — Toggle showing unreleased items
    /hv stats — Show completion statistics

Auction House (requires Auctionator or TSM)

    /hv ahscan all — Scan/cache AH prices for all profession decor
    /hv ahscan visible — Scan/cache AH prices for currently filtered/visible profession decor
    /hv ahscan status — Show AH scan status
    /hv ahscan stop — Stop the current AH scan

Tools / Debug

    /hv api on|off — Toggle API calls
    /hv zone [debug] — Open zone popup
    /hv mark [name] — Open vendor marker UI
    /hv mem [gc] — Show memory usage (optional GC)
    /hv diag — Debug DataManager/API state
    /hv debugnp [toggle] — Nameplate debug
    /hv cost <itemID> — Cost debug
    /hv item <itemID> — Item debug

Minimap Button

    Left-click: Open main UI
    Right-click: Open zone popup
    Drag: Move button position
