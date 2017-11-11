-- Dejunk: enUS (English) localization file.

local AddonName, AddonTable = ...
local L = LibStub('AceLocale-3.0'):NewLocale(AddonName, 'enUS', true)

L["ADDED_ITEM_TO_LIST"] = "Added %s to %s."
L["AUTO_REPAIR_TEXT"] = "Auto Repair"
L["AUTO_REPAIR_TOOLTIP"] = "Automatically repair items upon opening a merchant window.|n|nPrioritizes guild repairs when available."
L["AUTO_SELL_TEXT"] = "Auto Sell"
L["AUTO_SELL_TOOLTIP"] = "Automatically sell junk items upon opening a merchant window."
L["BACK_TEXT"] = "Back"
L["BY_QUALITY_TEXT"] = "By Quality:"
L["BY_TYPE_TEXT"] = "By Type:"
L["CHARACTER_SPECIFIC_TEXT"] = "Character Specific Settings"
L["CHARACTER_SPECIFIC_TOOLTIP"] = "Click this to toggle between global settings and settings specific to this character."
L["COLOR_SCHEME_SET_TEXT"] = "Color scheme set to %s."
L["COLOR_SCHEME_TEXT"] = "Scheme"
L["COMMON_TEXT"] = "Common"
L["DEJUNK_BUTTON_TOOLTIP"] = "Right-Click to toggle options."
L["DEJUNK_TEXT"] = "Dejunk"
L["DEJUNK_OPTIONS_TEXT"] = "DEJUNK"
L["DESTROY_TEXT"] = "Destroy"
L["DESTROY_OPTIONS_TEXT"] = "DESTROY"
L["DESTROYABLES_TEXT"] = "Destroyables"
L["DESTROYABLES_TOOLTIP"] = "Items on this list will be destroyed."
L["EPIC_TEXT"] = "Epic"
L["EXCLUSIONS_TEXT"] = "Exclusions"
L["EXCLUSIONS_TOOLTIP"] = "Items on this list will never be sold."
L["EXPORT_HELPER_TEXT"] = "When highlighted, use <Ctrl+C> or <Cmd+C> to copy the export string above."
L["EXPORT_LABEL_TEXT"] = "Export String"
L["EXPORT_TEXT"] = "Export"
L["EXPORT_TITLE_TEXT"] = "Exporting from %s"
L["FAILED_TO_PARSE_ITEM_ID"] = "Item ID %s failed to parse and may not exist."
L["GENERAL_TEXT"] = "General"
L["IGNORE_BATTLEPETS_TEXT"] = "Battle Pets"
L["IGNORE_BATTLEPETS_TOOLTIP"] = "Ignore battle and companion pets."
L["IGNORE_CONSUMABLES_TEXT"] = "Consumables"
L["IGNORE_CONSUMABLES_TOOLTIP"] = "Ignore consumable items such as food, potions, and Artifact Power."
L["IGNORE_GEMS_TEXT"] = "Gems"
L["IGNORE_GEMS_TOOLTIP"] = "Ignore cut gems and artifact relics."
L["IGNORE_GLYPHS_TEXT"] = "Glyphs"
L["IGNORE_GLYPHS_TOOLTIP"] = "Ignore glyphs."
L["IGNORE_ITEM_ENHANCEMENTS_TEXT"] = "Item Enhancements"
L["IGNORE_ITEM_ENHANCEMENTS_TOOLTIP"] = "Ignore items used for enhancing weapons and armor."
L["IGNORE_RECIPES_TEXT"] = "Recipes"
L["IGNORE_RECIPES_TOOLTIP"] = "Ignore tradeskill recipes."
L["IGNORE_TEXT"] = "Ignore"
L["IGNORE_TRADE_GOODS_TEXT"] = "Trade Goods"
L["IGNORE_TRADE_GOODS_TOOLTIP"] = "Ignore items related to crafting professions."
L["IMPORT_HELPER_TEXT"] = "Enter item IDs separated by a semi-colon (e.g. 4983;58907;67410)."
L["IMPORT_LABEL_TEXT"] = "Import String"
L["IMPORT_TEXT"] = "Import"
L["IMPORT_TITLE_TEXT"] = "Importing into %s"
L["INCLUSIONS_TEXT"] = "Inclusions"
L["INCLUSIONS_TOOLTIP"] = "Items on this list will always be sold."
L["ITEM_ALREADY_ON_LIST"] = "%s is already on %s."
L["ITEM_CANNOT_BE_SOLD"] = "%s cannot be sold."
L["ITEM_TOOLTIP_TEXT"] = "Item Tooltip"
L["ITEM_TOOLTIP_TOOLTIP"] = "Display a Dejunk message in an item's tooltip indicating whether or not it will be sold.|n|nThis tooltip only applies to items existing in your bags."
L["ITEM_WILL_BE_SOLD"] = "This item will be sold."
L["ITEM_WILL_NOT_BE_SOLD"] = "This item will not be sold."
L["LIST_FRAME_ADD_TOOLTIP"] = "To add an item, drop it into the frame below. (Items can only be added from your bags and inventory.)"
L["LIST_FRAME_REM_ALL_TOOLTIP"] = "To remove all items, hold <Shift+Alt> and Right-Click this title."
L["LIST_FRAME_REM_TOOLTIP"] = "To remove an item, highlight an entry and Right-Click."
L["MAY_NOT_HAVE_SOLD_ITEM"] = "May not have sold %s."
L["MINIMAP_CHECKBUTTON_TEXT"] = "Minimap Icon"
L["MINIMAP_CHECKBUTTON_TOOLTIP"] = "Display a Dejunk icon on the minimap."
L["MINIMAP_ICON_TOOLTIP_1"] = "Click to toggle options."
L["MINIMAP_ICON_TOOLTIP_2"] = "Drag to move this icon."
L["NO_CACHED_JUNK_ITEMS"] = "No junk items could be retrieved. Try again later."
L["NO_JUNK_ITEMS"] = "No junk items to sell."
L["ONLY_SELLING_CACHED"] = "Some items could not be retrieved. Only selling cached junk items."
L["POOR_TEXT"] = "Poor"
L["RARE_TEXT"] = "Rare"
L["REMOVED_ALL_FROM_LIST"] = "Removed all items from %s."
L["REMOVED_ITEM_FROM_LIST"] = "Removed %s from %s."
L["REPAIRED_ALL_ITEMS"] = "Repaired all items for %s."
L["REPAIRED_ALL_ITEMS_GUILD"] = "Repaired all items for %s (Guild)."
L["REPAIRED_NO_ITEMS"] = "Not enough money to repair."
L["SAFE_MODE_MESSAGE"] = "Safe Mode is enabled: only selling 12 items."
L["SAFE_MODE_TEXT"] = "Safe Mode"
L["SAFE_MODE_TOOLTIP"] = "Only sell up to 12 items at a time."
L["SCALE_TEXT"] = "Scale"
L["SCHEME_NAME_DEFAULT"] = "Default"
L["SCHEME_NAME_GRAYSCALE"] = "Grayscale"
L["SCHEME_NAME_GREENSCALE"] = "Greenscale"
L["SCHEME_NAME_REDSCALE"] = "Redscale"
L["SELL_ALL_TOOLTIP"] = "Sell all items of this quality."
L["SELL_TEXT"] = "Sell"
L["SELL_UNSUITABLE_TEXT"] = "Unsuitable Equipment"
L["SELL_UNSUITABLE_TOOLTIP"] = "Sell all weapons which are unsuitable for your class, and sell all armor which does not match your class’ primary armor type."
L["SILENT_MODE_TEXT"] = "Silent Mode"
L["SILENT_MODE_TOOLTIP"] = "Disable Dejunk chat window messages."
L["SOLD_YOUR_JUNK"] = "Sold your junk for %s."
L["UNCOMMON_TEXT"] = "Uncommon"
L["VENDOR_DOESNT_BUY"] = "Cannot sell to that merchant."

-- Sell below ilvl
L["SELL_EQUIPMENT_BELOW_ILVL_TEXT"] = "Equipment Below Item Level:"
L["SELL_EQUIPMENT_BELOW_ILVL_TOOLTIP"] = "Sell all equippable items below a specified item level (excluding tabards and shirts)."
