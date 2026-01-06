-- Spanish (Spain) Localization
if not HousingVendorLocales then
    HousingVendorLocales = {}
end

local L = {}

-- Main UI Strings
L["HOUSING_VENDOR_TITLE"] = "Ubicaciones de Decoración de Viviendas"
L["HOUSING_VENDOR_SUBTITLE"] = "Explora todas las decoraciones de viviendas de los vendedores en toda Azeroth"

-- Filter Labels
L["FILTER_SEARCH"] = "Buscar:"
L["FILTER_EXPANSION"] = "Expansión:"
L["FILTER_VENDOR"] = "Vendedor:"
L["FILTER_ZONE"] = "Zona:"
L["FILTER_TYPE"] = "Tipo:"
L["FILTER_CATEGORY"] = "Categoría:"
L["FILTER_FACTION"] = "Facción:"
L["FILTER_SOURCE"] = "Fuente:"
L["FILTER_PROFESSION"] = "Profesión:"
L["FILTER_CLEAR"] = "Limpiar filtros"
L["FILTER_ALL_EXPANSIONS"] = "Todas las expansiones"
L["FILTER_ALL_VENDORS"] = "Todos los vendedores"
L["FILTER_ALL_ZONES"] = "Todas las zonas"
L["FILTER_ALL_TYPES"] = "Todos los tipos"
L["FILTER_ALL_CATEGORIES"] = "Todas las categorías"
L["FILTER_ALL_SOURCES"] = "Todas las fuentes"
L["FILTER_ALL_FACTIONS"] = "Todas las facciones"

-- Column Headers
L["COLUMN_ITEM"] = "Objeto"
L["COLUMN_ITEM_NAME"] = "Nombre del objeto"
L["COLUMN_SOURCE"] = "Fuente"
L["COLUMN_LOCATION"] = "Ubicación"
L["COLUMN_PRICE"] = "Precio"
L["COLUMN_COST"] = "Coste"
L["COLUMN_VENDOR"] = "Vendedor"
L["COLUMN_TYPE"] = "Tipo"

-- Buttons
L["BUTTON_SETTINGS"] = "Configuración"
L["BUTTON_STATISTICS"] = "Estadísticas"
L["BUTTON_BACK"] = "Atrás"
L["BUTTON_CLOSE"] = "Cerrar"
L["BUTTON_CLOSE_X"] = "X"
L["SETTINGS_MULTI_SELECT_FILTERS"] = "Filtros de selección múltiple"
L["SETTINGS_HIDE_MINIMAP_BUTTON"] = "Ocultar botón del minimapa"
L["SETTINGS_HIDE_VISITED_VENDORS"] = "Ocultar vendedores visitados"
L["SETTINGS_AUTO_FILTER_BY_ZONE"] = "Filtrar automáticamente por zona"
L["SETTINGS_VENDOR_MARKER"] = "Marcador de vendedor"
L["SETTINGS_VENDOR_MARKER_DISTANCE_UNIT"] = "Unidad de distancia del marcador de vendedor"
L["AUCTION_HOUSE_PRICE_SOURCE"] = "Fuente de precios:"
L["STATUS_ALL"] = "Todos"
L["STATUS_COMPLETED"] = "Completado"
L["STATUS_INCOMPLETE"] = "Incompleto"
L["STATUS_IN_PROGRESS"] = "En progreso"
L["TOOLTIP_ACHIEVEMENTS"] = "Ver logros relacionados con vivienda\ny hacer seguimiento de tu progreso"
L["TOOLTIP_REPUTATION"] = "Hacer seguimiento de los requisitos de reputación\nentre todos tus personajes"
L["TOOLTIP_STATISTICS"] = "Ver estadísticas de colección\ny gráficos de progreso"
L["TOOLTIP_AUCTION_HOUSE"] = "Ver precios de subastas\n y buscar actualizaciones"
L["BUTTON_WAYPOINT"] = "Establecer punto de ruta"
L["BUTTON_SAVE"] = "Guardar"
L["BUTTON_RESET"] = "Restablecer"

-- Settings Panel
L["SETTINGS_TITLE"] = "Configuración del complemento de vivienda"
L["SETTINGS_GENERAL_TAB"] = "General"
L["SETTINGS_COMMUNITY_TAB"] = "Comunidad"
L["SETTINGS_MINIMAP_SECTION"] = "Botón del minimapa"
L["SETTINGS_SHOW_MINIMAP_BUTTON"] = "Mostrar botón del minimapa"
L["SETTINGS_UI_SCALE_SECTION"] = "Escala de interfaz"
L["SETTINGS_UI_SCALE"] = "Escala de interfaz"
L["SETTINGS_FONT_SIZE"] = "Tamaño de fuente"
L["SETTINGS_RESET"] = "Restablecer"
L["SETTINGS_RESET_DEFAULTS"] = "Restablecer valores predeterminados"
L["SETTINGS_PROGRESS_TRACKING"] = "Seguimiento de progreso"
L["SETTINGS_SHOW_COLLECTED"] = "Mostrar objetos coleccionados"
L["SETTINGS_WAYPOINT_NAVIGATION"] = "Navegación por puntos de ruta"
L["SETTINGS_USE_PORTAL_NAVIGATION"] = "Usar navegación inteligente por portal"

-- Tooltips
L["TOOLTIP_SETTINGS"] = "Configuración"
L["TOOLTIP_SETTINGS_DESC"] = "Configurar opciones del complemento"
L["TOOLTIP_WAYPOINT"] = "Establecer punto de ruta"
L["TOOLTIP_WAYPOINT_DESC"] = "Navegar a este vendedor"
L["TOOLTIP_PORTAL_NAVIGATION_ENABLED"] = "Navegación inteligente por portal habilitada"
L["TOOLTIP_PORTAL_NAVIGATION_DESC"] = "Usará automáticamente el portal más cercano al cambiar entre zonas"
L["TOOLTIP_DIRECT_NAVIGATION"] = "Navegación directa habilitada"
L["TOOLTIP_DIRECT_NAVIGATION_DESC"] = "Los puntos de ruta apuntarán directamente a las ubicaciones de los vendedores (no recomendado para viajes entre zonas)"

-- Info Panel Tooltips
L["TOOLTIP_INFO_EXPANSION"] = "La expansión de World of Warcraft de la que proviene este objeto"
L["TOOLTIP_INFO_FACTION"] = "Qué facción puede comprar este objeto del vendedor"
L["TOOLTIP_INFO_VENDOR"] = "Vendedor PNJ que vende este objeto"
L["TOOLTIP_INFO_VENDOR_WITH_COORDS"] = "Vendedor PNJ que vende este objeto\n\nUbicación: %s\nCoordenadas: %s"
L["TOOLTIP_INFO_ZONE"] = "Zona donde se encuentra este vendedor"
L["TOOLTIP_INFO_ZONE_WITH_COORDS"] = "Zona donde se encuentra este vendedor\n\nCoordenadas: %s"
L["TOOLTIP_INFO_REPUTATION"] = "Requisito de reputación para comprar este objeto del vendedor"
L["TOOLTIP_INFO_RENOWN"] = "Nivel de renombre requerido con una facción principal para desbloquear este objeto"
L["TOOLTIP_INFO_PROFESSION"] = "La profesión requerida para fabricar este objeto"
L["TOOLTIP_INFO_PROFESSION_SKILL"] = "Nivel de habilidad requerido en esta profesión para fabricar el objeto"
L["TOOLTIP_INFO_PROFESSION_RECIPE"] = "El nombre de la receta o patrón para fabricar este objeto"
L["TOOLTIP_INFO_EVENT"] = "Evento especial o festividad cuando este objeto está disponible"
L["TOOLTIP_INFO_CLASS"] = "Este objeto solo puede ser usado por esta clase"
L["TOOLTIP_INFO_RACE"] = "Este objeto solo puede ser usado por esta raza"

-- Messages
L["MESSAGE_PORTAL_NAV_ENABLED"] = "Navegación inteligente por portal habilitada. Los puntos de ruta usarán automáticamente el portal más cercano al cambiar entre zonas."
L["MESSAGE_DIRECT_NAV_ENABLED"] = "Navegación directa habilitada. Los puntos de ruta apuntarán directamente a las ubicaciones de los vendedores (no recomendado para viajes entre zonas)."

-- Community Section
L["COMMUNITY_TITLE"] = "Comunidad y Soporte"
L["COMMUNITY_INFO"] = "¡Únete a nuestra comunidad para compartir consejos, informar errores y sugerir nuevas funciones!"
L["COMMUNITY_DISCORD"] = "Servidor de Discord"
L["COMMUNITY_GITHUB"] = "GitHub"
L["COMMUNITY_REPORT_BUG"] = "Informar error"
L["COMMUNITY_SUGGEST_FEATURE"] = "Sugerir función"

-- Preview Panel
L["PREVIEW_TITLE"] = "Vista previa del objeto"
L["PREVIEW_NO_SELECTION"] = "Selecciona un objeto para ver detalles"

-- Status Bar
L["STATUS_ITEMS_DISPLAYED"] = "%d objetos mostrados (%d en total)"

-- Errors
L["ERROR_ADDON_NOT_INITIALIZED"] = "Complemento de vivienda no inicializado"
L["ERROR_UI_NOT_AVAILABLE"] = "Interfaz de HousingVendor no disponible"
L["ERROR_CONFIG_PANEL_NOT_AVAILABLE"] = "Panel de configuración no disponible"

-- Statistics UI
L["STATS_TITLE"] = "Panel de estadísticas"
L["STATS_COLLECTION_PROGRESS"] = "Progreso de la colección"
L["STATS_ITEMS_BY_SOURCE"] = "Objetos por fuente"
L["STATS_ITEMS_BY_FACTION"] = "Objetos por facción"
L["STATS_COLLECTION_BY_EXPANSION"] = "Colección por expansión"
L["STATS_COLLECTION_BY_CATEGORY"] = "Colección por categoría"
L["STATS_COMPLETE"] = "%d%% Completado - %d / %d objetos coleccionados"

-- Footer
L["FOOTER_COLOR_GUIDE"] = "Guía de colores:"
L["FOOTER_WAYPOINT_INSTRUCTION"] = "Haz clic en un objeto con %s para establecer un punto de ruta"

-- Main UI
L["MAIN_SUBTITLE"] = "Catálogo de vivienda"

-- Common Strings
L["COMMON_FREE"] = "Gratis"
L["COMMON_UNKNOWN"] = "Desconocido"
L["COMMON_NA"] = "N/D"
L["COMMON_GOLD"] = "oro"
L["COMMON_ITEM_ID"] = "ID del objeto:"

-- Miscellaneous
L["MINIMAP_TOOLTIP"] = "Explorador de vendedores de vivienda"
L["MINIMAP_TOOLTIP_DESC"] = "Haz clic izquierdo para alternar el explorador de vendedores de vivienda"

-- Expansion Names
L["EXPANSION_CLASSIC"] = "Clásico"
L["EXPANSION_THEBURNINGCRUSADE"] = "La Cruzada Ardiente"
L["EXPANSION_WRATHOFTHELLICHKING"] = "Ira del Rey Exánime"
L["EXPANSION_CATACLYSM"] = "Cataclismo"
L["EXPANSION_MISTSOFPANDARIA"] = "Nieblas de Pandaria"
L["EXPANSION_WARLORDSOF DRAENOR"] = "Señores de la Guerra de Draenor"
L["EXPANSION_LEGION"] = "Legión"
L["EXPANSION_BATTLEFORAZEROTH"] = "Batalla por Azeroth"
L["EXPANSION_SHADOWLANDS"] = "Shadowlands"
L["EXPANSION_DRAGONFLIGHT"] = "Dragonflight"
L["EXPANSION_THEWARWITHIN"] = "La Guerra Interior"
L["EXPANSION_MIDNIGHT"] = "Medianoche"

-- Faction Names
L["FACTION_ALLIANCE"] = "Alianza"
L["FACTION_HORDE"] = "Horda"
L["FACTION_NEUTRAL"] = "Neutral"

-- Source Types
L["SOURCE_VENDOR"] = "Vendedor"
L["SOURCE_ACHIEVEMENT"] = "Logro"
L["SOURCE_QUEST"] = "Misión"
L["SOURCE_DROP"] = "Botín"
L["SOURCE_PROFESSION"] = "Profesión"
L["SOURCE_REPUTATION"] = "Reputación"

-- Quality Names
L["QUALITY_POOR"] = "Pobre"
L["QUALITY_COMMON"] = "Común"
L["QUALITY_UNCOMMON"] = "Poco común"
L["QUALITY_RARE"] = "Raro"
L["QUALITY_EPIC"] = "Épico"
L["QUALITY_LEGENDARY"] = "Legendario"

-- Collection Status
L["COLLECTION_COLLECTED"] = "Coleccionado"
L["COLLECTION_UNCOLLECTED"] = "No coleccionado"

-- Requirement Types
L["REQUIREMENT_NONE"] = "Ninguno"
L["REQUIREMENT_ACHIEVEMENT"] = "Logro"
L["REQUIREMENT_QUEST"] = "Misión"
L["REQUIREMENT_REPUTATION"] = "Reputación"
L["REQUIREMENT_RENOWN"] = "Renombre"
L["REQUIREMENT_PROFESSION"] = "Profesión"

-- Common Category/Type Names
L["CATEGORY_FURNITURE"] = "Muebles"
L["CATEGORY_DECORATIONS"] = "Decoraciones"
L["CATEGORY_LIGHTING"] = "Iluminación"
L["CATEGORY_PLACEABLES"] = "Colocables"
L["CATEGORY_ACCESSORIES"] = "Accesorios"
L["CATEGORY_RUGS"] = "Alfombras"
L["CATEGORY_PLANTS"] = "Plantas"
L["CATEGORY_PAINTINGS"] = "Pinturas"
L["CATEGORY_BANNERS"] = "Estandartes"
L["CATEGORY_BOOKS"] = "Libros"
L["CATEGORY_FOOD"] = "Comida"
L["CATEGORY_TOYS"] = "Juguetes"

-- Type Names
L["TYPE_CHAIR"] = "Silla"
L["TYPE_TABLE"] = "Mesa"
L["TYPE_BED"] = "Cama"
L["TYPE_LAMP"] = "Lámpara"
L["TYPE_CANDLE"] = "Vela"
L["TYPE_RUG"] = "Alfombra"
L["TYPE_PAINTING"] = "Pintura"
L["TYPE_BANNER"] = "Estandarte"
L["TYPE_PLANT"] = "Planta"
L["TYPE_BOOKSHELF"] = "Estantería"
L["TYPE_CHEST"] = "Cofre"
L["TYPE_WEAPON_RACK"] = "Perchero de armas"

-- Filter Options
L["FILTER_HIDE_VISITED"] = "Ocultar visitados"
L["FILTER_ALL_QUALITIES"] = "Todas las calidades"
L["FILTER_ALL_REQUIREMENTS"] = "Todos los requisitos"

-- UI Theme Names
L["THEME_MIDNIGHT"] = "Medianoche"
L["THEME_ALLIANCE"] = "Alianza"
L["THEME_HORDE"] = "Horda"
L["THEME_SLEEK_BLACK"] = "Negro elegante"
L["SETTINGS_UI_THEME"] = "Tema de interfaz"

-- Make the locale table globally available
-- Added for Zone Popup / minimap behaviors
L["BUTTON_ZONE_POPUP"] = "Ventana emergente de zona"
L["BUTTON_MAIN_UI"] = "Interfaz principal"
L["SETTINGS_ZONE_POPUPS"] = "Ventanas emergentes de zona"
L["SETTINGS_ZONE_POPUPS_DESC"] = "Mostrar la ventana emergente de objetos pendientes al entrar en una nueva zona"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "Clic izquierdo: abrir ventana principal"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "Clic derecho: ventana emergente de zona"
L["MINIMAP_TOOLTIP_DRAG"] = "Arrastrar: mover botón"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "Objetos pendientes en la zona"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "Abre la ventana principal de HousingVendor filtrada a esta zona."

-- Auction House UI Strings
L["AUCTION_HOUSE_TITLE"] = "Casa de subastas"
L["AUCTION_HOUSE_SCAN"] = "Escanear"
L["AUCTION_HOUSE_FULL_SCAN"] = "Escaneo completo"
L["AUCTION_HOUSE_HINT"] = "Los precios se almacenan en caché por artículo. Requiere Auctionator o TSM. Haga clic en 'Escanear todo' para almacenar precios en caché."
L["AUCTION_HOUSE_STATUS"] = "Estado:"
L["AUCTION_HOUSE_LAST_SCAN"] = "Último escaneo:"
L["AUCTION_HOUSE_NO_PRICE"] = "Sin precio"
L["AUCTION_HOUSE_PRICES_CACHED"] = "precios en caché"
L["AUCTION_HOUSE_SCAN_STARTED"] = "Escaneo iniciado"
L["AUCTION_HOUSE_SCAN_COMPLETE"] = "Escaneo completo"
L["AUCTION_HOUSE_SCANNING"] = "Escaneando %d de %d (%s)"
L["AUCTION_HOUSE_OPEN"] = "Casa de subastas abierta"
L["AUCTION_HOUSE_CLOSED"] = "Casa de subastas cerrada"
L["AUCTION_HOUSE_OPEN_REQUIRED"] = "Abre la Casa de subastas antes de escanear"
L["AUCTION_HOUSE_ITEMS_DISPLAYED"] = "Mostrando %d objetos filtrados"
L["AUCTION_HOUSE_SHOWING_FIRST"] = "mostrando los primeros %d"

-- Achievements UI Strings
L["ACHIEVEMENTS_TITLE"] = "Logros de vivienda"
L["ACHIEVEMENTS_STATUS_ALL"] = "Todos"
L["ACHIEVEMENTS_STATUS_COMPLETED"] = "Completados"
L["ACHIEVEMENTS_STATUS_INCOMPLETE"] = "Incompletos"
L["ACHIEVEMENTS_STATUS_IN_PROGRESS"] = "En progreso"
L["ACHIEVEMENTS_FILTER_STATUS"] = "Estado:"
L["ACHIEVEMENTS_NO_DATA"] = "No hay datos de logros cargados.\n\nHaz clic en el botón 'Escanear' para cargar logros."
L["ACHIEVEMENTS_REWARD"] = "Recompensa:"
L["ACHIEVEMENTS_ID"] = "ID de logro:"
L["ACHIEVEMENTS_SCAN_BUTTON"] = "Escanear"
L["ACHIEVEMENTS_SCAN_STARTED"] = "Escaneando logros..."
L["ACHIEVEMENTS_SCAN_COMPLETE"] = "¡Escaneo completo! Escaneados %d logros, %d completados"
L["ACHIEVEMENTS_SEARCH_PLACEHOLDER"] = "Buscar logros..."

-- Reputation UI Strings
L["REPUTATION_TITLE"] = "Reputaciones de vivienda"
L["REPUTATION_ACCOUNT_WIDE"] = "A lo largo de la cuenta"
L["REPUTATION_TYPE"] = "Tipo:"
L["REPUTATION_TYPE_STANDARD"] = "Reputación estándar"
L["REPUTATION_TYPE_RENOWN"] = "Renombre (A lo largo de la cuenta)"
L["REPUTATION_CURRENT_PROGRESS"] = "Progreso actual:"
L["REPUTATION_TO_NEXT"] = "Hasta %s:"
L["REPUTATION_MAX_REACHED"] = "¡Nivel de reputación máximo alcanzado!"
L["REPUTATION_NOT_DISCOVERED"] = "Facción aún no descubierta - Visita la zona para desbloquearla"
L["REPUTATION_REQUIREMENT"] = "Requiere:"
L["REPUTATION_VENDORS"] = "Vendedores:"
L["REPUTATION_VENDORS_MORE"] = "+%d más"
L["REPUTATION_NO_VENDORS"] = "No se encontraron vendedores"
L["REPUTATION_CLICK_DETAILS"] = "Haz clic para más detalles"
L["REPUTATION_SEARCH_PLACEHOLDER"] = "Buscar reputaciones..."
L["REPUTATION_FACTION_ID"] = "ID de facción:"
L["REPUTATION_EXPANSION"] = "Expansión:"
L["REPUTATION_CATEGORY"] = "Categoría:"
L["REPUTATION_STANDING"] = "Posición:"
L["REPUTATION_DETAILS"] = "Detalles de reputación"

-- Minimap Button Strings
L["MINIMAP_TOOLTIP"] = "Navegador de vendedores de vivienda"
L["MINIMAP_TOOLTIP_DESC"] = "Clic izquierdo para alternar el navegador de vendedores de vivienda"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "Clic izquierdo: abrir ventana principal"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "Clic derecho: ventana emergente de zona"
L["MINIMAP_TOOLTIP_DRAG"] = "Arrastrar: mover botón"

-- Zone Popup Strings
L["BUTTON_MARK_VENDOR"] = "Marcar vendedor"
L["BUY_ON_AH_CURRENT_PRICE"] = "Comprar en casa de subastas (Precio actual):"
L["BUTTON_ZONE_POPUP"] = "Ventana emergente de zona"
L["BUTTON_MAIN_UI"] = "Interfaz principal"
L["SETTINGS_ZONE_POPUPS"] = "Ventanas emergentes de zona"
L["SETTINGS_ZONE_POPUPS_DESC"] = "Mostrar ventana emergente de objetos pendientes al entrar en una nueva zona"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "Objetos pendientes en zona"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "Abre la ventana principal de HousingVendor filtrada por esta zona."

HousingVendorLocales["esES"] = L
