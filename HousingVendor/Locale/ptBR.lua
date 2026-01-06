-- Portuguese (Brazil) Localization
if not HousingVendorLocales then
    HousingVendorLocales = {}
end

local L = {}

-- Main UI Strings
L["HOUSING_VENDOR_TITLE"] = "Locais de Decorações de Habitação"
L["HOUSING_VENDOR_SUBTITLE"] = "Navegue por todas as decorações de habitação de vendedores em Azeroth"

-- Filter Labels
L["FILTER_SEARCH"] = "Pesquisar:"
L["FILTER_EXPANSION"] = "Expansão:"
L["FILTER_VENDOR"] = "Vendedor:"
L["FILTER_ZONE"] = "Zona:"
L["FILTER_TYPE"] = "Tipo:"
L["FILTER_CATEGORY"] = "Categoria:"
L["FILTER_FACTION"] = "Facção:"
L["FILTER_SOURCE"] = "Fonte:"
L["FILTER_PROFESSION"] = "Profissão:"
L["FILTER_CLEAR"] = "Limpar filtros"
L["FILTER_ALL_EXPANSIONS"] = "Todas as expansões"
L["FILTER_ALL_VENDORS"] = "Todos os vendedores"
L["FILTER_ALL_ZONES"] = "Todas as zonas"
L["FILTER_ALL_TYPES"] = "Todos os tipos"
L["FILTER_ALL_CATEGORIES"] = "Todas as categorias"
L["FILTER_ALL_SOURCES"] = "Todas as fontes"
L["FILTER_ALL_FACTIONS"] = "Todas as facções"

-- Column Headers
L["COLUMN_ITEM"] = "Item"
L["COLUMN_ITEM_NAME"] = "Nome do item"
L["COLUMN_SOURCE"] = "Fonte"
L["COLUMN_LOCATION"] = "Localização"
L["COLUMN_PRICE"] = "Preço"
L["COLUMN_COST"] = "Custo"
L["COLUMN_VENDOR"] = "Vendedor"
L["COLUMN_TYPE"] = "Tipo"

-- Buttons
L["BUTTON_SETTINGS"] = "Configurações"
L["BUTTON_STATISTICS"] = "Estatísticas"
L["BUTTON_BACK"] = "Voltar"
L["BUTTON_CLOSE"] = "Fechar"
L["BUTTON_CLOSE_X"] = "X"
L["SETTINGS_MULTI_SELECT_FILTERS"] = "Filtros de Seleção Múltipla"
L["SETTINGS_HIDE_MINIMAP_BUTTON"] = "Ocultar botão do minimapa"
L["SETTINGS_HIDE_VISITED_VENDORS"] = "Ocultar vendedores visitados"
L["SETTINGS_AUTO_FILTER_BY_ZONE"] = "Filtrar automaticamente por zona"
L["SETTINGS_VENDOR_MARKER"] = "Marcador de vendedor"
L["SETTINGS_VENDOR_MARKER_DISTANCE_UNIT"] = "Unidade de distância do marcador de vendedor"
L["AUCTION_HOUSE_PRICE_SOURCE"] = "Fonte de preços:"
L["STATUS_ALL"] = "Todos"
L["STATUS_COMPLETED"] = "Concluído"
L["STATUS_INCOMPLETE"] = "Incompleto"
L["STATUS_IN_PROGRESS"] = "Em andamento"
L["TOOLTIP_ACHIEVEMENTS"] = "Ver conquistas relacionadas à habitação\ne acompanhar seu progresso"
L["TOOLTIP_REPUTATION"] = "Acompanhar os requisitos de reputação\nentre todos os seus personagens"
L["TOOLTIP_STATISTICS"] = "Ver estatísticas de coleção\ne gráficos de progresso"
L["TOOLTIP_AUCTION_HOUSE"] = "Ver preços dos leilões\ne procurar por atualizações"
L["BUTTON_WAYPOINT"] = "Definir ponto de referência"
L["BUTTON_SAVE"] = "Salvar"
L["BUTTON_RESET"] = "Redefinir"

-- Settings Panel
L["SETTINGS_TITLE"] = "Configurações do HousingVendor"
L["SETTINGS_GENERAL_TAB"] = "Geral"
L["SETTINGS_COMMUNITY_TAB"] = "Comunidade"
L["SETTINGS_MINIMAP_SECTION"] = "Botão do minimapa"
L["SETTINGS_SHOW_MINIMAP_BUTTON"] = "Mostrar botão do minimapa"
L["SETTINGS_UI_SCALE_SECTION"] = "Escala da interface"
L["SETTINGS_UI_SCALE"] = "Escala da interface"
L["SETTINGS_FONT_SIZE"] = "Tamanho da fonte"
L["SETTINGS_RESET"] = "Redefinir"
L["SETTINGS_RESET_DEFAULTS"] = "Redefinir para padrões"
L["SETTINGS_PROGRESS_TRACKING"] = "Acompanhamento de progresso"
L["SETTINGS_SHOW_COLLECTED"] = "Mostrar itens coletados"
L["SETTINGS_WAYPOINT_NAVIGATION"] = "Navegação por ponto de referência"
L["SETTINGS_USE_PORTAL_NAVIGATION"] = "Usar navegação inteligente por portal"

-- Tooltips
L["TOOLTIP_SETTINGS"] = "Configurações"
L["TOOLTIP_SETTINGS_DESC"] = "Configurar opções do addon"
L["TOOLTIP_WAYPOINT"] = "Definir ponto de referência"
L["TOOLTIP_WAYPOINT_DESC"] = "Navegar até este vendedor"
L["TOOLTIP_PORTAL_NAVIGATION_ENABLED"] = "Navegação inteligente por portal ativada"
L["TOOLTIP_PORTAL_NAVIGATION_DESC"] = "Usará automaticamente o portal mais próximo ao atravessar zonas"
L["TOOLTIP_DIRECT_NAVIGATION"] = "Navegação direta ativada"
L["TOOLTIP_DIRECT_NAVIGATION_DESC"] = "Os pontos de referência apontarão diretamente para os locais dos vendedores (não recomendado para viagens entre zonas)"

-- Info Panel Tooltips
L["TOOLTIP_INFO_EXPANSION"] = "A expansão do World of Warcraft de onde vem este item"
L["TOOLTIP_INFO_FACTION"] = "Qual facção pode comprar este item do vendedor"
L["TOOLTIP_INFO_VENDOR"] = "Vendedor NPC que vende este item"
L["TOOLTIP_INFO_VENDOR_WITH_COORDS"] = "Vendedor NPC que vende este item\n\nLocalização: %s\nCoordenadas: %s"
L["TOOLTIP_INFO_ZONE"] = "Zona onde este vendedor está localizado"
L["TOOLTIP_INFO_ZONE_WITH_COORDS"] = "Zona onde este vendedor está localizado\n\nCoordenadas: %s"
L["TOOLTIP_INFO_REPUTATION"] = "Requisito de reputação para comprar este item do vendedor"
L["TOOLTIP_INFO_RENOWN"] = "Nível de renome necessário com uma facção principal para desbloquear este item"
L["TOOLTIP_INFO_PROFESSION"] = "A profissão necessária para criar este item"
L["TOOLTIP_INFO_PROFESSION_SKILL"] = "Nível de habilidade necessário nesta profissão para criar o item"
L["TOOLTIP_INFO_PROFESSION_RECIPE"] = "O nome da receita ou padrão para criar este item"
L["TOOLTIP_INFO_EVENT"] = "Evento especial ou feriado quando este item está disponível"
L["TOOLTIP_INFO_CLASS"] = "Este item só pode ser usado por esta classe"
L["TOOLTIP_INFO_RACE"] = "Este item só pode ser usado por esta raça"

-- Messages
L["MESSAGE_PORTAL_NAV_ENABLED"] = "Navegação inteligente por portal ativada. Os pontos de referência usarão automaticamente o portal mais próximo ao atravessar zonas."
L["MESSAGE_DIRECT_NAV_ENABLED"] = "Navegação direta ativada. Os pontos de referência apontarão diretamente para os locais dos vendedores (não recomendado para viagens entre zonas)."

-- Community Section
L["COMMUNITY_TITLE"] = "Comunidade e suporte"
L["COMMUNITY_INFO"] = "Junte-se à nossa comunidade para compartilhar dicas, relatar bugs e sugerir novos recursos!"
L["COMMUNITY_DISCORD"] = "Servidor do Discord"
L["COMMUNITY_GITHUB"] = "GitHub"
L["COMMUNITY_REPORT_BUG"] = "Relatar bug"
L["COMMUNITY_SUGGEST_FEATURE"] = "Sugerir recurso"

-- Preview Panel
L["PREVIEW_TITLE"] = "Pré-visualização do item"
L["PREVIEW_NO_SELECTION"] = "Selecione um item para ver detalhes"

-- Status Bar
L["STATUS_ITEMS_DISPLAYED"] = "%d itens exibidos (%d no total)"

-- Errors
L["ERROR_ADDON_NOT_INITIALIZED"] = "Addon de habitação não inicializado"
L["ERROR_UI_NOT_AVAILABLE"] = "Interface do HousingVendor não disponível"
L["ERROR_CONFIG_PANEL_NOT_AVAILABLE"] = "Painel de configuração não disponível"

-- Statistics UI
L["STATS_TITLE"] = "Painel de estatísticas"
L["STATS_COLLECTION_PROGRESS"] = "Progresso da coleção"
L["STATS_ITEMS_BY_SOURCE"] = "Itens por fonte"
L["STATS_ITEMS_BY_FACTION"] = "Itens por facção"
L["STATS_COLLECTION_BY_EXPANSION"] = "Coleção por expansão"
L["STATS_COLLECTION_BY_CATEGORY"] = "Coleção por categoria"
L["STATS_COMPLETE"] = "%d%% completo - %d / %d itens coletados"

-- Footer
L["FOOTER_COLOR_GUIDE"] = "Guia de cores:"
L["FOOTER_WAYPOINT_INSTRUCTION"] = "Clique em um item com %s para definir um ponto de referência"

-- Main UI
L["MAIN_SUBTITLE"] = "Catálogo de habitação"

-- Common Strings
L["COMMON_FREE"] = "Grátis"
L["COMMON_UNKNOWN"] = "Desconhecido"
L["COMMON_NA"] = "N/D"
L["COMMON_GOLD"] = "ouro"
L["COMMON_ITEM_ID"] = "ID do item:"

-- Miscellaneous
L["MINIMAP_TOOLTIP"] = "Navegador de vendedores de habitação"
L["MINIMAP_TOOLTIP_DESC"] = "Clique com o botão esquerdo para alternar o navegador de vendedores de habitação"

-- Expansion Names
L["EXPANSION_CLASSIC"] = "Clássico"
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
L["EXPANSION_MIDNIGHT"] = "Meia-noite"

-- Faction Names
L["FACTION_ALLIANCE"] = "Aliança"
L["FACTION_HORDE"] = "Horda"
L["FACTION_NEUTRAL"] = "Neutro"

-- Source Types
L["SOURCE_VENDOR"] = "Vendedor"
L["SOURCE_ACHIEVEMENT"] = "Conquista"
L["SOURCE_QUEST"] = "Missão"
L["SOURCE_DROP"] = "Saque"
L["SOURCE_PROFESSION"] = "Profissão"
L["SOURCE_REPUTATION"] = "Reputação"

-- Quality Names
L["QUALITY_POOR"] = "Pobre"
L["QUALITY_COMMON"] = "Comum"
L["QUALITY_UNCOMMON"] = "Incomum"
L["QUALITY_RARE"] = "Raro"
L["QUALITY_EPIC"] = "Épico"
L["QUALITY_LEGENDARY"] = "Lendário"

-- Collection Status
L["COLLECTION_COLLECTED"] = "Coletado"
L["COLLECTION_UNCOLLECTED"] = "Não coletado"

-- Requirement Types
L["REQUIREMENT_NONE"] = "Nenhum"
L["REQUIREMENT_ACHIEVEMENT"] = "Conquista"
L["REQUIREMENT_QUEST"] = "Missão"
L["REQUIREMENT_REPUTATION"] = "Reputação"
L["REQUIREMENT_RENOWN"] = "Renome"
L["REQUIREMENT_PROFESSION"] = "Profissão"

-- Common Category/Type Names
L["CATEGORY_FURNITURE"] = "Móveis"
L["CATEGORY_DECORATIONS"] = "Decorações"
L["CATEGORY_LIGHTING"] = "Iluminação"
L["CATEGORY_PLACEABLES"] = "Colocáveis"
L["CATEGORY_ACCESSORIES"] = "Acessórios"
L["CATEGORY_RUGS"] = "Tapetes"
L["CATEGORY_PLANTS"] = "Plantas"
L["CATEGORY_PAINTINGS"] = "Pinturas"
L["CATEGORY_BANNERS"] = "Bandeiras"
L["CATEGORY_BOOKS"] = "Livros"
L["CATEGORY_FOOD"] = "Comida"
L["CATEGORY_TOYS"] = "Brinquedos"

-- Type Names
L["TYPE_CHAIR"] = "Cadeira"
L["TYPE_TABLE"] = "Mesa"
L["TYPE_BED"] = "Cama"
L["TYPE_LAMP"] = "Lâmpada"
L["TYPE_CANDLE"] = "Vela"
L["TYPE_RUG"] = "Tapete"
L["TYPE_PAINTING"] = "Pintura"
L["TYPE_BANNER"] = "Bandeira"
L["TYPE_PLANT"] = "Planta"
L["TYPE_BOOKSHELF"] = "Estante"
L["TYPE_CHEST"] = "Baú"
L["TYPE_WEAPON_RACK"] = "Suporte de armas"

-- Filter Options
L["FILTER_HIDE_VISITED"] = "Ocultar visitados"
L["FILTER_ALL_QUALITIES"] = "Todas as qualidades"
L["FILTER_ALL_REQUIREMENTS"] = "Todos os requisitos"

-- UI Theme Names
L["THEME_MIDNIGHT"] = "Meia-noite"
L["THEME_ALLIANCE"] = "Aliança"
L["THEME_HORDE"] = "Horda"
L["THEME_SLEEK_BLACK"] = "Preto elegante"
L["SETTINGS_UI_THEME"] = "Tema da interface"

-- Added for Zone Popup / minimap behaviors
L["BUTTON_ZONE_POPUP"] = "Popup da zona"
L["BUTTON_MAIN_UI"] = "Janela principal"
L["SETTINGS_ZONE_POPUPS"] = "Popups de zona"
L["SETTINGS_ZONE_POPUPS_DESC"] = "Mostrar o popup de itens pendentes ao entrar em uma nova zona"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "Clique esquerdo: abrir janela principal"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "Clique direito: popup de zona"
L["MINIMAP_TOOLTIP_DRAG"] = "Arrastar: mover botão"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "Itens pendentes na zona"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "Abre a janela principal do HousingVendor filtrada para esta zona."

-- Auction House UI Strings
L["AUCTION_HOUSE_TITLE"] = "Casa de Leilões"
L["AUCTION_HOUSE_SCAN"] = "Escanear"
L["AUCTION_HOUSE_FULL_SCAN"] = "Varredura completa"
L["AUCTION_HOUSE_HINT"] = "Os preços são armazenados em cache por item. Requer Auctionator ou TSM. Clique em 'Escanear tudo' para armazenar os preços em cache."
L["AUCTION_HOUSE_STATUS"] = "Status:"
L["AUCTION_HOUSE_LAST_SCAN"] = "Última varredura:"
L["AUCTION_HOUSE_NO_PRICE"] = "Sem preço"
L["AUCTION_HOUSE_PRICES_CACHED"] = "preços em cache"
L["AUCTION_HOUSE_SCAN_STARTED"] = "Varredura iniciada"
L["AUCTION_HOUSE_SCAN_COMPLETE"] = "Varredura completa"
L["AUCTION_HOUSE_SCANNING"] = "Escaneando %d de %d (%s)"
L["AUCTION_HOUSE_OPEN"] = "Casa de Leilões aberta"
L["AUCTION_HOUSE_CLOSED"] = "Casa de Leilões fechada"
L["AUCTION_HOUSE_OPEN_REQUIRED"] = "Abra a Casa de Leilões antes de escanear"
L["AUCTION_HOUSE_ITEMS_DISPLAYED"] = "Exibindo %d itens filtrados"
L["AUCTION_HOUSE_SHOWING_FIRST"] = "mostrando os primeiros %d"

-- Achievements UI Strings
L["ACHIEVEMENTS_TITLE"] = "Conquistas de Habitação"
L["ACHIEVEMENTS_STATUS_ALL"] = "Todos"
L["ACHIEVEMENTS_STATUS_COMPLETED"] = "Concluídas"
L["ACHIEVEMENTS_STATUS_INCOMPLETE"] = "Incompletas"
L["ACHIEVEMENTS_STATUS_IN_PROGRESS"] = "Em andamento"
L["ACHIEVEMENTS_FILTER_STATUS"] = "Status:"
L["ACHIEVEMENTS_NO_DATA"] = "Nenhum dado de conquistas carregado.\n\nClique no botão 'Escanear' para carregar conquistas."
L["ACHIEVEMENTS_REWARD"] = "Recompensa:"
L["ACHIEVEMENTS_ID"] = "ID da conquista:"
L["ACHIEVEMENTS_SCAN_BUTTON"] = "Escanear"
L["ACHIEVEMENTS_SCAN_STARTED"] = "Escaneando conquistas..."
L["ACHIEVEMENTS_SCAN_COMPLETE"] = "Varredura completa! %d conquistas escaneadas, %d concluídas"
L["ACHIEVEMENTS_SEARCH_PLACEHOLDER"] = "Buscar conquistas..."

-- Reputation UI Strings
L["REPUTATION_TITLE"] = "Reputações de Habitação"
L["REPUTATION_ACCOUNT_WIDE"] = "Conta inteira"
L["REPUTATION_TYPE"] = "Tipo:"
L["REPUTATION_TYPE_STANDARD"] = "Reputação padrão"
L["REPUTATION_TYPE_RENOWN"] = "Renome (Conta inteira)"
L["REPUTATION_CURRENT_PROGRESS"] = "Progresso atual:"
L["REPUTATION_TO_NEXT"] = "Para %s:"
L["REPUTATION_MAX_REACHED"] = "Nível máximo de reputação alcançado!"
L["REPUTATION_NOT_DISCOVERED"] = "Facção ainda não descoberta - Visite a zona para desbloquear"
L["REPUTATION_REQUIREMENT"] = "Requer:"
L["REPUTATION_VENDORS"] = "Vendedores:"
L["REPUTATION_VENDORS_MORE"] = "+%d mais"
L["REPUTATION_NO_VENDORS"] = "Nenhum vendedor encontrado"
L["REPUTATION_CLICK_DETAILS"] = "Clique para mais detalhes"
L["REPUTATION_SEARCH_PLACEHOLDER"] = "Buscar reputações..."
L["REPUTATION_FACTION_ID"] = "ID da Facção:"
L["REPUTATION_EXPANSION"] = "Expansão:"
L["REPUTATION_CATEGORY"] = "Categoria:"
L["REPUTATION_STANDING"] = "Posição:"
L["REPUTATION_DETAILS"] = "Detalhes da reputação"

-- Minimap Button Strings
L["MINIMAP_TOOLTIP"] = "Navegador de Vendedores de Habitação"
L["MINIMAP_TOOLTIP_DESC"] = "Clique com botão esquerdo para alternar o navegador de vendedores de habitação"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "Clique esquerdo: abrir janela principal"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "Clique direito: popup de zona"
L["MINIMAP_TOOLTIP_DRAG"] = "Arrastar: mover botão"

-- Zone Popup Strings
L["BUTTON_MARK_VENDOR"] = "Marcar vendedor"
L["BUY_ON_AH_CURRENT_PRICE"] = "Comprar na Casa de Leilões (Preço atual):"
L["BUTTON_ZONE_POPUP"] = "Popup de Zona"
L["BUTTON_MAIN_UI"] = "Interface Principal"
L["SETTINGS_ZONE_POPUPS"] = "Popups de Zona"
L["SETTINGS_ZONE_POPUPS_DESC"] = "Mostrar popup de itens pendentes ao entrar em uma nova zona"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "Itens pendentes na Zona"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "Abre a janela principal do HousingVendor filtrada por esta zona."

HousingVendorLocales["ptBR"] = L

