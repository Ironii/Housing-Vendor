-- Italian Localization
if not HousingVendorLocales then
    HousingVendorLocales = {}
end

local L = {}

-- Main UI Strings
L["HOUSING_VENDOR_TITLE"] = "Posizioni delle Decorazioni dell'Abitazione"
L["HOUSING_VENDOR_SUBTITLE"] = "Sfoglia tutte le decorazioni dell'abitazione dei venditori in tutta Azeroth"

-- Filter Labels
L["FILTER_SEARCH"] = "Ricerca:"
L["FILTER_EXPANSION"] = "Espansione:"
L["FILTER_VENDOR"] = "Venditore:"
L["FILTER_ZONE"] = "Zona:"
L["FILTER_TYPE"] = "Tipo:"
L["FILTER_CATEGORY"] = "Categoria:"
L["FILTER_FACTION"] = "Fazione:"
L["FILTER_SOURCE"] = "Fonte:"
L["FILTER_PROFESSION"] = "Professione:"
L["FILTER_CLEAR"] = "Cancella Filtri"
L["FILTER_ALL_EXPANSIONS"] = "Tutte le Espansioni"
L["FILTER_ALL_VENDORS"] = "Tutti i Venditori"
L["FILTER_ALL_ZONES"] = "Tutte le Zone"
L["FILTER_ALL_TYPES"] = "Tutti i Tipi"
L["FILTER_ALL_CATEGORIES"] = "Tutte le Categorie"
L["FILTER_ALL_SOURCES"] = "Tutte le Fonti"
L["FILTER_ALL_FACTIONS"] = "Tutte le Fazioni"

-- Column Headers
L["COLUMN_ITEM"] = "Oggetto"
L["COLUMN_ITEM_NAME"] = "Nome Oggetto"
L["COLUMN_SOURCE"] = "Fonte"
L["COLUMN_LOCATION"] = "Posizione"
L["COLUMN_PRICE"] = "Prezzo"
L["COLUMN_COST"] = "Costo"
L["COLUMN_VENDOR"] = "Venditore"
L["COLUMN_TYPE"] = "Tipo"

-- Buttons
L["BUTTON_SETTINGS"] = "Impostazioni"
L["BUTTON_STATISTICS"] = "Statistiche"
L["BUTTON_BACK"] = "Indietro"
L["BUTTON_CLOSE"] = "Chiudi"
L["BUTTON_CLOSE_X"] = "X"
L["SETTINGS_MULTI_SELECT_FILTERS"] = "Filtri a selezione multipla"
L["SETTINGS_HIDE_MINIMAP_BUTTON"] = "Nascondi pulsante minimappa"
L["SETTINGS_HIDE_VISITED_VENDORS"] = "Nascondi venditori visitati"
L["SETTINGS_AUTO_FILTER_BY_ZONE"] = "Filtro automatico per zona"
L["SETTINGS_VENDOR_MARKER"] = "Marcatore venditore"
L["SETTINGS_VENDOR_MARKER_DISTANCE_UNIT"] = "Unità di distanza marcatore venditore"
L["AUCTION_HOUSE_PRICE_SOURCE"] = "Fonte prezzi:"
L["STATUS_ALL"] = "Tutti"
L["STATUS_COMPLETED"] = "Completato"
L["STATUS_INCOMPLETE"] = "Incompleto"
L["STATUS_IN_PROGRESS"] = "In corso"
L["TOOLTIP_ACHIEVEMENTS"] = "Visualizza le imprese legate all'abitazione\ne traccia i tuoi progressi"
L["TOOLTIP_REPUTATION"] = "Tieni traccia dei requisiti di reputazione\nper tutti i tuoi personaggi"
L["TOOLTIP_STATISTICS"] = "Visualizza le statistiche di collezione\ne i grafici dei progressi"
L["TOOLTIP_AUCTION_HOUSE"] = "Visualizza i prezzi all'asta\ne cerca aggiornamenti"
L["BUTTON_WAYPOINT"] = "Imposta Punto di Riferimento"
L["BUTTON_SAVE"] = "Salva"
L["BUTTON_RESET"] = "Reimposta"

-- Settings Panel
L["SETTINGS_TITLE"] = "Impostazioni dell'Addon dell'Abitazione"
L["SETTINGS_GENERAL_TAB"] = "Generale"
L["SETTINGS_COMMUNITY_TAB"] = "Comunità"
L["SETTINGS_MINIMAP_SECTION"] = "Pulsante della Minimappa"
L["SETTINGS_SHOW_MINIMAP_BUTTON"] = "Mostra Pulsante della Minimappa"
L["SETTINGS_UI_SCALE_SECTION"] = "Scala dell'Interfaccia"
L["SETTINGS_UI_SCALE"] = "Scala dell'Interfaccia"
L["SETTINGS_FONT_SIZE"] = "Dimensione Carattere"
L["SETTINGS_RESET"] = "Reimposta"
L["SETTINGS_RESET_DEFAULTS"] = "Reimposta ai Predefiniti"
L["SETTINGS_PROGRESS_TRACKING"] = "Tracciamento dei Progressi"
L["SETTINGS_SHOW_COLLECTED"] = "Mostra Oggetti Raccolti"
L["SETTINGS_WAYPOINT_NAVIGATION"] = "Navigazione tramite Punti di Riferimento"
L["SETTINGS_USE_PORTAL_NAVIGATION"] = "Usa Navigazione Intelligente tramite Portali"

-- Tooltips
L["TOOLTIP_SETTINGS"] = "Impostazioni"
L["TOOLTIP_SETTINGS_DESC"] = "Configura le opzioni dell'addon"
L["TOOLTIP_WAYPOINT"] = "Imposta Punto di Riferimento"
L["TOOLTIP_WAYPOINT_DESC"] = "Naviga verso questo venditore"
L["TOOLTIP_PORTAL_NAVIGATION_ENABLED"] = "Navigazione Intelligente tramite Portali Abilitata"
L["TOOLTIP_PORTAL_NAVIGATION_DESC"] = "Userà automaticamente il portale più vicino quando si attraversano le zone"
L["TOOLTIP_DIRECT_NAVIGATION"] = "Navigazione diretta abilitata"
L["TOOLTIP_DIRECT_NAVIGATION_DESC"] = "I punti di riferimento punteranno direttamente alle posizioni dei venditori (non consigliato per i viaggi tra zone)"

-- Info Panel Tooltips
L["TOOLTIP_INFO_EXPANSION"] = "L'espansione di World of Warcraft da cui proviene questo oggetto"
L["TOOLTIP_INFO_FACTION"] = "Quale fazione può acquistare questo oggetto dal venditore"
L["TOOLTIP_INFO_VENDOR"] = "Venditore PNG che vende questo oggetto"
L["TOOLTIP_INFO_VENDOR_WITH_COORDS"] = "Venditore PNG che vende questo oggetto\n\nPosizione: %s\nCoordinate: %s"
L["TOOLTIP_INFO_ZONE"] = "Zona in cui si trova questo venditore"
L["TOOLTIP_INFO_ZONE_WITH_COORDS"] = "Zona in cui si trova questo venditore\n\nCoordinate: %s"
L["TOOLTIP_INFO_REPUTATION"] = "Requisito di reputazione per acquistare questo oggetto dal venditore"
L["TOOLTIP_INFO_RENOWN"] = "Livello di fama richiesto con una fazione principale per sbloccare questo oggetto"
L["TOOLTIP_INFO_PROFESSION"] = "La professione richiesta per creare questo oggetto"
L["TOOLTIP_INFO_PROFESSION_SKILL"] = "Livello di abilità richiesto in questa professione per creare l'oggetto"
L["TOOLTIP_INFO_PROFESSION_RECIPE"] = "Il nome della ricetta o schema per creare questo oggetto"
L["TOOLTIP_INFO_EVENT"] = "Evento speciale o festività in cui questo oggetto è disponibile"
L["TOOLTIP_INFO_CLASS"] = "Questo oggetto può essere usato solo da questa classe"
L["TOOLTIP_INFO_RACE"] = "Questo oggetto può essere usato solo da questa razza"

-- Messages
L["MESSAGE_PORTAL_NAV_ENABLED"] = "Navigazione intelligente tramite portali abilitata. I punti di riferimento useranno automaticamente il portale più vicino quando si attraversano le zone."
L["MESSAGE_DIRECT_NAV_ENABLED"] = "Navigazione diretta abilitata. I punti di riferimento punteranno direttamente alle posizioni dei venditori (non consigliato per i viaggi tra zone)."

-- Community Section
L["COMMUNITY_TITLE"] = "Comunità e Supporto"
L["COMMUNITY_INFO"] = "Unisciti alla nostra comunità per condividere consigli, segnalare bug e suggerire nuove funzionalità!"
L["COMMUNITY_DISCORD"] = "Server Discord"
L["COMMUNITY_GITHUB"] = "GitHub"
L["COMMUNITY_REPORT_BUG"] = "Segnala Bug"
L["COMMUNITY_SUGGEST_FEATURE"] = "Suggerisci Funzionalità"

-- Preview Panel
L["PREVIEW_TITLE"] = "Anteprima Oggetto"
L["PREVIEW_NO_SELECTION"] = "Seleziona un oggetto per visualizzare i dettagli"

-- Status Bar
L["STATUS_ITEMS_DISPLAYED"] = "%d oggetti visualizzati (%d totali)"

-- Errors
L["ERROR_ADDON_NOT_INITIALIZED"] = "Addon dell'abitazione non inizializzato"
L["ERROR_UI_NOT_AVAILABLE"] = "Interfaccia utente di HousingVendor non disponibile"
L["ERROR_CONFIG_PANEL_NOT_AVAILABLE"] = "Pannello di configurazione non disponibile"

-- Statistics UI
L["STATS_TITLE"] = "Dashboard Statistiche"
L["STATS_COLLECTION_PROGRESS"] = "Progresso Collezione"
L["STATS_ITEMS_BY_SOURCE"] = "Oggetti per Fonte"
L["STATS_ITEMS_BY_FACTION"] = "Oggetti per Fazione"
L["STATS_COLLECTION_BY_EXPANSION"] = "Collezione per Espansione"
L["STATS_COLLECTION_BY_CATEGORY"] = "Collezione per Categoria"
L["STATS_COMPLETE"] = "%d%% Completato - %d / %d oggetti raccolti"

-- Footer
L["FOOTER_COLOR_GUIDE"] = "Guida Colori:"
L["FOOTER_WAYPOINT_INSTRUCTION"] = "Clicca su un oggetto con %s per impostare un punto di riferimento"

-- Main UI
L["MAIN_SUBTITLE"] = "Catalogo Abitazione"

-- Common Strings
L["COMMON_FREE"] = "Gratis"
L["COMMON_UNKNOWN"] = "Sconosciuto"
L["COMMON_NA"] = "N/D"
L["COMMON_GOLD"] = "oro"
L["COMMON_ITEM_ID"] = "ID Oggetto:"

-- Miscellaneous
L["MINIMAP_TOOLTIP"] = "Browser dei Venditori dell'Abitazione"
L["MINIMAP_TOOLTIP_DESC"] = "Clic sinistro per attivare/disattivare il browser dei venditori dell'abitazione"

-- Expansion Names
L["EXPANSION_CLASSIC"] = "Classico"
L["EXPANSION_THEBURNINGCRUSADE"] = "The Burning Crusade"
L["EXPANSION_WRATHOFTHELLICHKING"] = "Wrath of the Lich King"
L["EXPANSION_CATACLYSM"] = "Cataclysm"
L["EXPANSION_MISTSOFPANDARIA"] = "Mists of Pandaria"
L["EXPANSION_WARLORDSOF DRAENOR"] = "Warlords of Draenor"
L["EXPANSION_LEGION"] = "Legion"
L["EXPANSION_BATTLEFORAZEROTH"] = "Battle for Azeroth"
L["EXPANSION_SHADOWLANDS"] = "Shadowlands"
L["EXPANSION_DRAGONFLIGHT"] = "Dragonflight"
L["EXPANSION_THEWARWITHIN"] = "The War Within"
L["EXPANSION_MIDNIGHT"] = "Mezzanotte"

-- Faction Names
L["FACTION_ALLIANCE"] = "Alleanza"
L["FACTION_HORDE"] = "Orda"
L["FACTION_NEUTRAL"] = "Neutrale"

-- Source Types
L["SOURCE_VENDOR"] = "Venditore"
L["SOURCE_ACHIEVEMENT"] = "Impresa"
L["SOURCE_QUEST"] = "Missione"
L["SOURCE_DROP"] = "Bottino"
L["SOURCE_PROFESSION"] = "Professione"
L["SOURCE_REPUTATION"] = "Reputazione"

-- Quality Names
L["QUALITY_POOR"] = "Scadente"
L["QUALITY_COMMON"] = "Comune"
L["QUALITY_UNCOMMON"] = "Non comune"
L["QUALITY_RARE"] = "Raro"
L["QUALITY_EPIC"] = "Epico"
L["QUALITY_LEGENDARY"] = "Leggendario"

-- Collection Status
L["COLLECTION_COLLECTED"] = "Raccolto"
L["COLLECTION_UNCOLLECTED"] = "Non raccolto"

-- Requirement Types
L["REQUIREMENT_NONE"] = "Nessuno"
L["REQUIREMENT_ACHIEVEMENT"] = "Impresa"
L["REQUIREMENT_QUEST"] = "Missione"
L["REQUIREMENT_REPUTATION"] = "Reputazione"
L["REQUIREMENT_RENOWN"] = "Fama"
L["REQUIREMENT_PROFESSION"] = "Professione"

-- Common Category/Type Names
L["CATEGORY_FURNITURE"] = "Mobili"
L["CATEGORY_DECORATIONS"] = "Decorazioni"
L["CATEGORY_LIGHTING"] = "Illuminazione"
L["CATEGORY_PLACEABLES"] = "Posizionabili"
L["CATEGORY_ACCESSORIES"] = "Accessori"
L["CATEGORY_RUGS"] = "Tappeti"
L["CATEGORY_PLANTS"] = "Piante"
L["CATEGORY_PAINTINGS"] = "Dipinti"
L["CATEGORY_BANNERS"] = "Stendardi"
L["CATEGORY_BOOKS"] = "Libri"
L["CATEGORY_FOOD"] = "Cibo"
L["CATEGORY_TOYS"] = "Giocattoli"

-- Type Names
L["TYPE_CHAIR"] = "Sedia"
L["TYPE_TABLE"] = "Tavolo"
L["TYPE_BED"] = "Letto"
L["TYPE_LAMP"] = "Lampada"
L["TYPE_CANDLE"] = "Candela"
L["TYPE_RUG"] = "Tappeto"
L["TYPE_PAINTING"] = "Dipinto"
L["TYPE_BANNER"] = "Stendardo"
L["TYPE_PLANT"] = "Pianta"
L["TYPE_BOOKSHELF"] = "Libreria"
L["TYPE_CHEST"] = "Cassa"
L["TYPE_WEAPON_RACK"] = "Rastrelliera per armi"

-- Filter Options
L["FILTER_HIDE_VISITED"] = "Nascondi visitati"
L["FILTER_ALL_QUALITIES"] = "Tutte le qualità"
L["FILTER_ALL_REQUIREMENTS"] = "Tutti i requisiti"

-- UI Theme Names
L["THEME_MIDNIGHT"] = "Mezzanotte"
L["THEME_ALLIANCE"] = "Alleanza"
L["THEME_HORDE"] = "Orda"
L["THEME_SLEEK_BLACK"] = "Nero elegante"
L["SETTINGS_UI_THEME"] = "Tema interfaccia"

-- Make the locale table globally available
-- Added for Zone Popup / minimap behaviors
L["BUTTON_ZONE_POPUP"] = "Popup zona"
L["BUTTON_MAIN_UI"] = "Interfaccia principale"
L["SETTINGS_ZONE_POPUPS"] = "Popup zona"
L["SETTINGS_ZONE_POPUPS_DESC"] = "Mostra il popup degli oggetti mancanti quando entri in una nuova zona"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "Clic sinistro: apri finestra principale"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "Clic destro: popup zona"
L["MINIMAP_TOOLTIP_DRAG"] = "Trascina: sposta pulsante"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "Oggetti mancanti nella zona"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "Apre la finestra principale di HousingVendor filtrata per questa zona."

-- Auction House UI Strings
L["AUCTION_HOUSE_TITLE"] = "Casa d'aste"
L["AUCTION_HOUSE_SCAN"] = "Scansiona"
L["AUCTION_HOUSE_FULL_SCAN"] = "Scansione completa"
L["AUCTION_HOUSE_HINT"] = "I prezzi sono memorizzati nella cache per oggetto. Richiede Auctionator o TSM. Clicca 'Scansiona tutto' per memorizzare i prezzi nella cache."
L["AUCTION_HOUSE_STATUS"] = "Stato:"
L["AUCTION_HOUSE_LAST_SCAN"] = "Ultima scansione:"
L["AUCTION_HOUSE_NO_PRICE"] = "Nessun prezzo"
L["AUCTION_HOUSE_PRICES_CACHED"] = "prezzi memorizzati"
L["AUCTION_HOUSE_SCAN_STARTED"] = "Scansione iniziata"
L["AUCTION_HOUSE_SCAN_COMPLETE"] = "Scansione completata"
L["AUCTION_HOUSE_SCANNING"] = "Scansione di %d di %d (%s)"
L["AUCTION_HOUSE_OPEN"] = "Casa d'aste aperta"
L["AUCTION_HOUSE_CLOSED"] = "Casa d'aste chiusa"
L["AUCTION_HOUSE_OPEN_REQUIRED"] = "Apri la Casa d'aste prima di scansionare"
L["AUCTION_HOUSE_ITEMS_DISPLAYED"] = "Visualizzazione di %d oggetti filtrati"
L["AUCTION_HOUSE_SHOWING_FIRST"] = "mostrando i primi %d"

-- Achievements UI Strings
L["ACHIEVEMENTS_TITLE"] = "Imprese di arredamento"
L["ACHIEVEMENTS_STATUS_ALL"] = "Tutti"
L["ACHIEVEMENTS_STATUS_COMPLETED"] = "Completati"
L["ACHIEVEMENTS_STATUS_INCOMPLETE"] = "Incompleti"
L["ACHIEVEMENTS_STATUS_IN_PROGRESS"] = "In corso"
L["ACHIEVEMENTS_FILTER_STATUS"] = "Stato:"
L["ACHIEVEMENTS_NO_DATA"] = "Nessun dato delle imprese caricato.\n\nClicca sul pulsante 'Scansiona' per caricare le imprese."
L["ACHIEVEMENTS_REWARD"] = "Ricompensa:"
L["ACHIEVEMENTS_ID"] = "ID impresa:"
L["ACHIEVEMENTS_SCAN_BUTTON"] = "Scansiona"
L["ACHIEVEMENTS_SCAN_STARTED"] = "Scansione delle imprese in corso..."
L["ACHIEVEMENTS_SCAN_COMPLETE"] = "Scansione completata! %d imprese scansionate, %d completate"
L["ACHIEVEMENTS_SEARCH_PLACEHOLDER"] = "Cerca imprese..."

-- Reputation UI Strings
L["REPUTATION_TITLE"] = "Reputazioni per arredamento"
L["REPUTATION_ACCOUNT_WIDE"] = "Account completo"
L["REPUTATION_TYPE"] = "Tipo:"
L["REPUTATION_TYPE_STANDARD"] = "Reputazione standard"
L["REPUTATION_TYPE_RENOWN"] = "Fama (Account completo)"
L["REPUTATION_CURRENT_PROGRESS"] = "Progresso attuale:"
L["REPUTATION_TO_NEXT"] = "A %s:"
L["REPUTATION_MAX_REACHED"] = "Livello di reputazione massimo raggiunto!"
L["REPUTATION_NOT_DISCOVERED"] = "Fazione non ancora scoperta - Visita la zona per sbloccarla"
L["REPUTATION_REQUIREMENT"] = "Richiede:"
L["REPUTATION_VENDORS"] = "Mercanti:"
L["REPUTATION_VENDORS_MORE"] = "+%d in più"
L["REPUTATION_NO_VENDORS"] = "Nessun mercante trovato"
L["REPUTATION_CLICK_DETAILS"] = "Clicca per maggiori dettagli"
L["REPUTATION_SEARCH_PLACEHOLDER"] = "Cerca reputazioni..."
L["REPUTATION_FACTION_ID"] = "ID Fazione:"
L["REPUTATION_EXPANSION"] = "Espansione:"
L["REPUTATION_CATEGORY"] = "Categoria:"
L["REPUTATION_STANDING"] = "Posizione:"
L["REPUTATION_DETAILS"] = "Dettagli reputazione"

-- Minimap Button Strings
L["MINIMAP_TOOLTIP"] = "Browser mercanti arredamento"
L["MINIMAP_TOOLTIP_DESC"] = "Clic sinistro per attivare/disattivare il browser mercanti arredamento"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "Clic sinistro: apri finestra principale"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "Clic destro: popup zona"
L["MINIMAP_TOOLTIP_DRAG"] = "Trascina: sposta pulsante"

-- Zone Popup Strings
L["BUTTON_MARK_VENDOR"] = "Marca venditore"
L["BUY_ON_AH_CURRENT_PRICE"] = "Compra all'asta (Prezzo attuale):"
L["BUTTON_ZONE_POPUP"] = "Popup zona"
L["BUTTON_MAIN_UI"] = "Interfaccia principale"
L["SETTINGS_ZONE_POPUPS"] = "Popup zona"
L["SETTINGS_ZONE_POPUPS_DESC"] = "Mostra popup oggetti in sospeso quando entri in una nuova zona"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "Oggetti in sospeso nella zona"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "Apre la finestra principale di HousingVendor filtrata per questa zona."

HousingVendorLocales["itIT"] = L
