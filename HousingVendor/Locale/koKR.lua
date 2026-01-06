-- Korean Localization
if not HousingVendorLocales then
    HousingVendorLocales = {}
end

local L = {}

-- Main UI Strings
L["HOUSING_VENDOR_TITLE"] = "주택 장식 위치"
L["HOUSING_VENDOR_SUBTITLE"] = "아제로스 전역의 판매자들로부터 모든 주택 장식 찾아보기"

-- Filter Labels
L["FILTER_SEARCH"] = "검색:"
L["FILTER_EXPANSION"] = "확장팩:"
L["FILTER_VENDOR"] = "판매자:"
L["FILTER_ZONE"] = "지역:"
L["FILTER_TYPE"] = "유형:"
L["FILTER_CATEGORY"] = "분류:"
L["FILTER_FACTION"] = "진영:"
L["FILTER_SOURCE"] = "출처:"
L["FILTER_PROFESSION"] = "전문기술:"
L["FILTER_CLEAR"] = "필터 지우기"
L["FILTER_ALL_EXPANSIONS"] = "모든 확장팩"
L["FILTER_ALL_VENDORS"] = "모든 판매자"
L["FILTER_ALL_ZONES"] = "모든 지역"
L["FILTER_ALL_TYPES"] = "모든 유형"
L["FILTER_ALL_CATEGORIES"] = "모든 분류"
L["FILTER_ALL_SOURCES"] = "모든 출처"
L["FILTER_ALL_FACTIONS"] = "모든 진영"

-- Column Headers
L["COLUMN_ITEM"] = "아이템"
L["COLUMN_ITEM_NAME"] = "아이템 이름"
L["COLUMN_SOURCE"] = "출처"
L["COLUMN_LOCATION"] = "위치"
L["COLUMN_PRICE"] = "가격"
L["COLUMN_COST"] = "비용"
L["COLUMN_VENDOR"] = "판매자"
L["COLUMN_TYPE"] = "유형"

-- Buttons
L["BUTTON_SETTINGS"] = "설정"
L["BUTTON_STATISTICS"] = "통계"
L["BUTTON_BACK"] = "뒤로"
L["BUTTON_CLOSE"] = "닫기"
L["BUTTON_CLOSE_X"] = "X"
L["SETTINGS_MULTI_SELECT_FILTERS"] = "다중 선택 필터"
L["SETTINGS_HIDE_MINIMAP_BUTTON"] = "미니맵 버튼 숨기기"
L["SETTINGS_HIDE_VISITED_VENDORS"] = "방문한 상인 숨기기"
L["SETTINGS_AUTO_FILTER_BY_ZONE"] = "지역별 자동 필터링"
L["SETTINGS_VENDOR_MARKER"] = "상인 표시기"
L["SETTINGS_VENDOR_MARKER_DISTANCE_UNIT"] = "상인 표시기 거리 단위"
L["AUCTION_HOUSE_PRICE_SOURCE"] = "가격 출처:"
L["STATUS_ALL"] = "모두"
L["STATUS_COMPLETED"] = "완료됨"
L["STATUS_INCOMPLETE"] = "미완료"
L["STATUS_IN_PROGRESS"] = "진행 중"
L["TOOLTIP_ACHIEVEMENTS"] = "주택 관련 업적 보기\n및 진행 상황 추적"
L["TOOLTIP_REPUTATION"] = "모든 캐릭터의 평판\n요구 사항 추적"
L["TOOLTIP_STATISTICS"] = "수집 통계 보기\n및 진행 차트"
L["TOOLTIP_AUCTION_HOUSE"] = "경매 가격 보기\n및 업데이트 검색"
L["BUTTON_WAYPOINT"] = "웨이포인트 설정"
L["BUTTON_SAVE"] = "저장"
L["BUTTON_RESET"] = "초기화"

-- Settings Panel
L["SETTINGS_TITLE"] = "주택 애드온 설정"
L["SETTINGS_GENERAL_TAB"] = "일반"
L["SETTINGS_COMMUNITY_TAB"] = "커뮤니티"
L["SETTINGS_MINIMAP_SECTION"] = "미니맵 버튼"
L["SETTINGS_SHOW_MINIMAP_BUTTON"] = "미니맵 버튼 표시"
L["SETTINGS_UI_SCALE_SECTION"] = "UI 크기 조절"
L["SETTINGS_UI_SCALE"] = "UI 크기 조절"
L["SETTINGS_FONT_SIZE"] = "글꼴 크기"
L["SETTINGS_RESET"] = "초기화"
L["SETTINGS_RESET_DEFAULTS"] = "기본값으로 재설정"
L["SETTINGS_PROGRESS_TRACKING"] = "진행 상황 추적"
L["SETTINGS_SHOW_COLLECTED"] = "수집한 아이템 표시"
L["SETTINGS_WAYPOINT_NAVIGATION"] = "웨이포인트 탐색"
L["SETTINGS_USE_PORTAL_NAVIGATION"] = "스마트 포털 탐색 사용"

-- Tooltips
L["TOOLTIP_SETTINGS"] = "설정"
L["TOOLTIP_SETTINGS_DESC"] = "애드온 옵션 구성"
L["TOOLTIP_WAYPOINT"] = "웨이포인트 설정"
L["TOOLTIP_WAYPOINT_DESC"] = "이 판매자에게 이동"
L["TOOLTIP_PORTAL_NAVIGATION_ENABLED"] = "스마트 포털 탐색 활성화됨"
L["TOOLTIP_PORTAL_NAVIGATION_DESC"] = "지역 간 이동 시 자동으로 가장 가까운 포털을 사용합니다"
L["TOOLTIP_DIRECT_NAVIGATION"] = "직접 탐색 활성화됨"
L["TOOLTIP_DIRECT_NAVIGATION_DESC"] = "웨이포인트가 판매자 위치를 직접 가리킵니다 (지역 간 이동에는 권장되지 않음)"

-- Info Panel Tooltips
L["TOOLTIP_INFO_EXPANSION"] = "이 아이템이 속한 월드 오브 워크래프트 확장팩"
L["TOOLTIP_INFO_FACTION"] = "판매자에게서 이 아이템을 구매할 수 있는 진영"
L["TOOLTIP_INFO_VENDOR"] = "이 아이템을 판매하는 NPC 판매자"
L["TOOLTIP_INFO_VENDOR_WITH_COORDS"] = "이 아이템을 판매하는 NPC 판매자\n\n위치: %s\n좌표: %s"
L["TOOLTIP_INFO_ZONE"] = "이 판매자가 위치한 지역"
L["TOOLTIP_INFO_ZONE_WITH_COORDS"] = "이 판매자가 위치한 지역\n\n좌표: %s"
L["TOOLTIP_INFO_REPUTATION"] = "판매자에게서 이 아이템을 구매하는 데 필요한 평판"
L["TOOLTIP_INFO_RENOWN"] = "이 아이템을 잠금 해제하는 데 필요한 주요 진영의 명성 레벨"
L["TOOLTIP_INFO_PROFESSION"] = "이 아이템을 제작하는 데 필요한 전문 기술"
L["TOOLTIP_INFO_PROFESSION_SKILL"] = "아이템을 제작하는 데 필요한 이 전문 기술의 숙련도"
L["TOOLTIP_INFO_PROFESSION_RECIPE"] = "이 아이템을 제작하기 위한 조리법 또는 도안 이름"
L["TOOLTIP_INFO_EVENT"] = "이 아이템을 구할 수 있는 특별 이벤트 또는 기념일"
L["TOOLTIP_INFO_CLASS"] = "이 아이템은 이 직업만 사용할 수 있습니다"
L["TOOLTIP_INFO_RACE"] = "이 아이템은 이 종족만 사용할 수 있습니다"

-- Messages
L["MESSAGE_PORTAL_NAV_ENABLED"] = "스마트 포털 탐색이 활성화되었습니다. 지역 간 이동 시 웨이포인트가 자동으로 가장 가까운 포털을 사용합니다."
L["MESSAGE_DIRECT_NAV_ENABLED"] = "직접 탐색이 활성화되었습니다. 웨이포인트가 판매자 위치를 직접 가리킵니다 (지역 간 이동에는 권장되지 않음)."

-- Community Section
L["COMMUNITY_TITLE"] = "커뮤니티 및 지원"
L["COMMUNITY_INFO"] = "팁을 공유하고, 버그를 신고하며, 새로운 기능을 제안하려면 커뮤니티에 참여하세요!"
L["COMMUNITY_DISCORD"] = "디스코드 서버"
L["COMMUNITY_GITHUB"] = "GitHub"
L["COMMUNITY_REPORT_BUG"] = "버그 신고"
L["COMMUNITY_SUGGEST_FEATURE"] = "기능 제안"

-- Preview Panel
L["PREVIEW_TITLE"] = "아이템 미리보기"
L["PREVIEW_NO_SELECTION"] = "상세 정보를 보려면 아이템을 선택하세요"

-- Status Bar
L["STATUS_ITEMS_DISPLAYED"] = "%d개 아이템 표시됨 (총 %d개)"

-- Errors
L["ERROR_ADDON_NOT_INITIALIZED"] = "주택 애드온이 초기화되지 않았습니다"
L["ERROR_UI_NOT_AVAILABLE"] = "HousingVendor UI를 사용할 수 없습니다"
L["ERROR_CONFIG_PANEL_NOT_AVAILABLE"] = "구성 패널을 사용할 수 없습니다"

-- Statistics UI
L["STATS_TITLE"] = "통계 대시보드"
L["STATS_COLLECTION_PROGRESS"] = "수집 진행률"
L["STATS_ITEMS_BY_SOURCE"] = "출처별 아이템"
L["STATS_ITEMS_BY_FACTION"] = "진영별 아이템"
L["STATS_COLLECTION_BY_EXPANSION"] = "확장팩별 수집"
L["STATS_COLLECTION_BY_CATEGORY"] = "분류별 수집"
L["STATS_COMPLETE"] = "%d%% 완료 - %d / %d개 아이템 수집됨"

-- Footer
L["FOOTER_COLOR_GUIDE"] = "색상 가이드:"
L["FOOTER_WAYPOINT_INSTRUCTION"] = "%s가 있는 아이템을 클릭하여 웨이포인트 설정"

-- Main UI
L["MAIN_SUBTITLE"] = "주택 카탈로그"

-- Common Strings
L["COMMON_FREE"] = "무료"
L["COMMON_UNKNOWN"] = "알 수 없음"
L["COMMON_NA"] = "해당 없음"
L["COMMON_GOLD"] = "골드"
L["COMMON_ITEM_ID"] = "아이템 ID:"

-- Miscellaneous
L["MINIMAP_TOOLTIP"] = "주택 판매자 브라우저"
L["MINIMAP_TOOLTIP_DESC"] = "왼쪽 클릭으로 주택 판매자 브라우저 전환"

-- Expansion Names
L["EXPANSION_CLASSIC"] = "클래식"
L["EXPANSION_THEBURNINGCRUSADE"] = "불타는 성전"
L["EXPANSION_WRATHOFTHELLICHKING"] = "리치왕의 분노"
L["EXPANSION_CATACLYSM"] = "대격변"
L["EXPANSION_MISTSOFPANDARIA"] = "판다리아의 안개"
L["EXPANSION_WARLORDSOF DRAENOR"] = "드레노어의 전쟁군주"
L["EXPANSION_LEGION"] = "군단"
L["EXPANSION_BATTLEFORAZEROTH"] = "격전의 아제로스"
L["EXPANSION_SHADOWLANDS"] = "어둠의 때"
L["EXPANSION_DRAGONFLIGHT"] = "용군단"
L["EXPANSION_THEWARWITHIN"] = "내면의 전쟁"
L["EXPANSION_MIDNIGHT"] = "자정"

-- Faction Names
L["FACTION_ALLIANCE"] = "염맹"
L["FACTION_HORDE"] = "호드"
L["FACTION_NEUTRAL"] = "중립"

-- Source Types
L["SOURCE_VENDOR"] = "판매자"
L["SOURCE_ACHIEVEMENT"] = "업적"
L["SOURCE_QUEST"] = "퀴스트"
L["SOURCE_DROP"] = "드롭"
L["SOURCE_PROFESSION"] = "전문기술"
L["SOURCE_REPUTATION"] = "평판"

-- Quality Names
L["QUALITY_POOR"] = "후라한"
L["QUALITY_COMMON"] = "일반적인"
L["QUALITY_UNCOMMON"] = "희귀한"
L["QUALITY_RARE"] = "희귀한"
L["QUALITY_EPIC"] = "영웅한"
L["QUALITY_LEGENDARY"] = "전설적인"

-- Collection Status
L["COLLECTION_COLLECTED"] = "수집됨"
L["COLLECTION_UNCOLLECTED"] = "미수집"

-- Requirement Types
L["REQUIREMENT_NONE"] = "없음"
L["REQUIREMENT_ACHIEVEMENT"] = "업적"
L["REQUIREMENT_QUEST"] = "퀴스트"
L["REQUIREMENT_REPUTATION"] = "평판"
L["REQUIREMENT_RENOWN"] = "명망"
L["REQUIREMENT_PROFESSION"] = "전문기술"

-- Common Category/Type Names
L["CATEGORY_FURNITURE"] = "가구"
L["CATEGORY_DECORATIONS"] = "장식"
L["CATEGORY_LIGHTING"] = "조명"
L["CATEGORY_PLACEABLES"] = "배치 가능"
L["CATEGORY_ACCESSORIES"] = "액세서리"
L["CATEGORY_RUGS"] = "양탄자"
L["CATEGORY_PLANTS"] = "식물"
L["CATEGORY_PAINTINGS"] = "그림"
L["CATEGORY_BANNERS"] = "현수막"
L["CATEGORY_BOOKS"] = "책"
L["CATEGORY_FOOD"] = "음식"
L["CATEGORY_TOYS"] = "장난감"

-- Type Names
L["TYPE_CHAIR"] = "의자"
L["TYPE_TABLE"] = "테이블"
L["TYPE_BED"] = "침대"
L["TYPE_LAMP"] = "램프"
L["TYPE_CANDLE"] = "초"
L["TYPE_RUG"] = "양탄자"
L["TYPE_PAINTING"] = "그림"
L["TYPE_BANNER"] = "현수막"
L["TYPE_PLANT"] = "식물"
L["TYPE_BOOKSHELF"] = "책장"
L["TYPE_CHEST"] = "상자"
L["TYPE_WEAPON_RACK"] = "무기 거치대"

-- Filter Options
L["FILTER_HIDE_VISITED"] = "방문함 숨기기"
L["FILTER_ALL_QUALITIES"] = "모든 품질"
L["FILTER_ALL_REQUIREMENTS"] = "모든 요구사항"

-- UI Theme Names
L["THEME_MIDNIGHT"] = "자정"
L["THEME_ALLIANCE"] = "염맹"
L["THEME_HORDE"] = "호드"
L["THEME_SLEEK_BLACK"] = "세련된 검정"
L["SETTINGS_UI_THEME"] = "UI 테마"

-- Make the locale table globally available
-- Added for Zone Popup / minimap behaviors
L["BUTTON_ZONE_POPUP"] = "지역 팝업"
L["BUTTON_MAIN_UI"] = "메인 창"
L["SETTINGS_ZONE_POPUPS"] = "지역 팝업"
L["SETTINGS_ZONE_POPUPS_DESC"] = "새 지역에 들어갈 때 미수집 아이템 팝업 표시"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "왼쪽 클릭: 메인 창 열기"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "오른쪽 클릭: 지역 팝업"
L["MINIMAP_TOOLTIP_DRAG"] = "드래그: 버튼 이동"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "지역 내 미수집 아이템"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "이 지역으로 필터링된 HousingVendor 메인 창을 엽니다."

-- Auction House UI Strings
L["AUCTION_HOUSE_TITLE"] = "경매장"
L["AUCTION_HOUSE_SCAN"] = "스캔"
L["AUCTION_HOUSE_FULL_SCAN"] = "전체 스캔"
L["AUCTION_HOUSE_HINT"] = "가격은 아이템별로 캐시됩니다. Auctionator 또는 TSM이 필요합니다. 가격을 캐시하려면 '모두 스캔'을 클릭하세요."
L["AUCTION_HOUSE_STATUS"] = "상태:"
L["AUCTION_HOUSE_LAST_SCAN"] = "마지막 스캔:"
L["AUCTION_HOUSE_NO_PRICE"] = "가격 없음"
L["AUCTION_HOUSE_PRICES_CACHED"] = "가격 캐시됨"
L["AUCTION_HOUSE_SCAN_STARTED"] = "스캔 시작됨"
L["AUCTION_HOUSE_SCAN_COMPLETE"] = "스캔 완료"
L["AUCTION_HOUSE_SCANNING"] = "%d/%d 스캔 중 (%s)"
L["AUCTION_HOUSE_OPEN"] = "경매장 열림"
L["AUCTION_HOUSE_CLOSED"] = "경매장 닫힘"
L["AUCTION_HOUSE_OPEN_REQUIRED"] = "스캔 전에 경매장을 열어주세요"
L["AUCTION_HOUSE_ITEMS_DISPLAYED"] = "%d개의 필터된 아이템 표시 중"
L["AUCTION_HOUSE_SHOWING_FIRST"] = "처음 %d개 표시 중"

-- Achievements UI Strings
L["ACHIEVEMENTS_TITLE"] = "주택 관련 업적"
L["ACHIEVEMENTS_STATUS_ALL"] = "모두"
L["ACHIEVEMENTS_STATUS_COMPLETED"] = "달성함"
L["ACHIEVEMENTS_STATUS_INCOMPLETE"] = "미달성"
L["ACHIEVEMENTS_STATUS_IN_PROGRESS"] = "진행 중"
L["ACHIEVEMENTS_FILTER_STATUS"] = "상태:"
L["ACHIEVEMENTS_NO_DATA"] = "업적 데이터가 로드되지 않았습니다.\n\n'스캔' 버튼을 클릭하여 업적을 로드하세요."
L["ACHIEVEMENTS_REWARD"] = "보상:"
L["ACHIEVEMENTS_ID"] = "업적 ID:"
L["ACHIEVEMENTS_SCAN_BUTTON"] = "스캔"
L["ACHIEVEMENTS_SCAN_STARTED"] = "업적 스캔 중..."
L["ACHIEVEMENTS_SCAN_COMPLETE"] = "스캔 완료! %d개의 업적 스캔, %d개 달성함"
L["ACHIEVEMENTS_SEARCH_PLACEHOLDER"] = "업적 검색..."

-- Reputation UI Strings
L["REPUTATION_TITLE"] = "주택 관련 평판"
L["REPUTATION_ACCOUNT_WIDE"] = "계정 전체"
L["REPUTATION_TYPE"] = "유형:"
L["REPUTATION_TYPE_STANDARD"] = "일반 평판"
L["REPUTATION_TYPE_RENOWN"] = "위상 (계정 전체)"
L["REPUTATION_CURRENT_PROGRESS"] = "현재 진행 상황:"
L["REPUTATION_TO_NEXT"] = "%s까지:"
L["REPUTATION_MAX_REACHED"] = "최대 평판 수치에 도달했습니다!"
L["REPUTATION_NOT_DISCOVERED"] = "진영이 아직 발견되지 않음 - 해제하려면 지역을 방문하세요"
L["REPUTATION_REQUIREMENT"] = "필요 조건:"
L["REPUTATION_VENDORS"] = "상인:"
L["REPUTATION_VENDORS_MORE"] = "+%d개 더"
L["REPUTATION_NO_VENDORS"] = "상인을 찾을 수 없음"
L["REPUTATION_CLICK_DETAILS"] = "자세한 내용을 보려면 클릭"
L["REPUTATION_SEARCH_PLACEHOLDER"] = "평판 검색..."
L["REPUTATION_FACTION_ID"] = "진영 ID:"
L["REPUTATION_EXPANSION"] = "확장팩:"
L["REPUTATION_CATEGORY"] = "분류:"
L["REPUTATION_STANDING"] = "지위:"
L["REPUTATION_DETAILS"] = "평판 세부 정보"

-- Minimap Button Strings
L["MINIMAP_TOOLTIP"] = "주택 상인 브라우저"
L["MINIMAP_TOOLTIP_DESC"] = "왼쪽 클릭하여 주택 상인 브라우저 전환"
L["MINIMAP_TOOLTIP_LEFTCLICK"] = "왼쪽 클릭: 주 창 열기"
L["MINIMAP_TOOLTIP_RIGHTCLICK"] = "오른쪽 클릭: 지역 팝업"
L["MINIMAP_TOOLTIP_DRAG"] = "드래그: 버튼 이동"

-- Zone Popup Strings
L["BUTTON_MARK_VENDOR"] = "상인 표시"
L["BUY_ON_AH_CURRENT_PRICE"] = "경매장에서 구매 (현재 가격):"
L["BUTTON_ZONE_POPUP"] = "지역 팝업"
L["BUTTON_MAIN_UI"] = "주 UI"
L["SETTINGS_ZONE_POPUPS"] = "지역 팝업"
L["SETTINGS_ZONE_POPUPS_DESC"] = "새 지역에 진입할 때 미달성 아이템 팝업 표시"
L["OUTSTANDING_ITEMS_IN_ZONE"] = "지역 내 미달성 아이템"
L["OUTSTANDING_MAIN_UI_TOOLTIP_DESC"] = "이 지역으로 필터링된 주택 상인 주 창을 엽니다."

HousingVendorLocales["koKR"] = L
