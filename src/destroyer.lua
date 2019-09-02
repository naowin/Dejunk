-- Destroyer: handles the process of destroying items in the player's bags.

local AddonName, Addon = ...

-- Libs
local L = Addon.Libs.L
local DBL = Addon.Libs.DBL
local DTL = Addon.Libs.DTL

-- Upvalues
local assert, format, tremove = assert, format, table.remove

local GetCursorInfo, PickupContainerItem, DeleteCursorItem, ClearCursor =
      GetCursorInfo, PickupContainerItem, DeleteCursorItem, ClearCursor
local LE_ITEM_QUALITY_POOR = LE_ITEM_QUALITY_POOR
local GetCoinTextureString = _G.GetCoinTextureString

-- Modules
local Destroyer = Addon.Destroyer

local Confirmer = Addon.Confirmer
local Consts = Addon.Consts
local Core = Addon.Core
local DB = Addon.DB
local ListManager = Addon.ListManager
local Tools = Addon.Tools
local UI = Addon.UI

-- Variables
local states = {
  None = 0,
  Destroying = 1
}
local currentState = states.None

local itemsToDestroy = {}

-- ============================================================================
-- Destroying Functions
-- ============================================================================

do
  -- Attempts to start the Destroying process if Auto Destroy is enabled.
  function Destroyer:StartAutoDestroy()
    if (currentState ~= states.None) then return end
    if not DB.Profile.AutoDestroy then return end
    if UI:IsShown() then return end

    -- NOTE: We don't use self.Filter since DBL will call without args
    DBL:GetItemsByFilter(Destroyer.Filter, itemsToDestroy)
    if (#itemsToDestroy > 0) then Destroyer:StartDestroying(true) end
  end
  -- Register DBL listener
  DBL:AddListener(Destroyer.StartAutoDestroy)

  -- Starts the Destroying process.
  -- @param auto - if the process was started automatically
  function Destroyer:StartDestroying(auto)
    local canDestroy, msg = Core:CanDestroy()
    if not canDestroy then
      if not auto then Core:Print(msg) end
      return
    end

    Confirmer:Start("Destroyer")
    currentState = states.Destroying
    self.incompleteTooltips = false

    -- Update items if manually started
    if not auto then DBL:GetItemsByFilter(Destroyer.Filter, itemsToDestroy) end
    local upToDate = DBL:IsUpToDate()

    -- Notify if tooltips could not be scanned
    if self.incompleteTooltips then
      self.incompleteTooltips = false
      Core:Print(L.IGNORING_ITEMS_INCOMPLETE_TOOLTIPS)
    end

    -- Stop if no items
    if (#itemsToDestroy == 0) then
      if not auto then
        Core:Print(upToDate and L.NO_DESTROYABLE_ITEMS or L.NO_CACHED_DESTROYABLE_ITEMS)
      end
      self:StopDestroying()
      return
    end

    -- If DBL isn't up to date, we'll only have items that are cached
    if not upToDate then Core:Print(L.ONLY_DESTROYING_CACHED) end

    self:StartDestroyingItems()
  end

  -- Cancels the Destroying process.
  function Destroyer:StopDestroying()
    assert(currentState ~= states.None)
    self.OnUpdate = nil
    Confirmer:Stop("Destroyer")
    currentState = states.None
  end

  -- Checks whether or not the Destroyer is active.
  -- @return - boolean
  function Destroyer:IsDestroying()
    return (currentState ~= states.None)
  end

  -- Returns true if the Destroyer is active or items are being confirmed.
  function Destroyer:IsBusy()
    return self:IsDestroying() or Confirmer:IsConfirming("Destroyer")
  end
end

-- ============================================================================
-- Destroy Item Functions
-- ============================================================================

do
  local interval = 0

  -- Destroying update function
  local function destroyItems_OnUpdate(self, elapsed)
    interval = interval + elapsed
    if (interval >= Core.MinDelay) then
      interval = 0

      -- Don't run if the cursor has an item, spell, etc.
      if GetCursorInfo() then return end
      -- Get next item
      local item = tremove(itemsToDestroy)
      -- Stop if there are no more items
      if not item then Destroyer:StopDestroyingItems() return end
      -- Otherwise, verify that the item in the bag slot has not been changed before destroying
      if not DBL:StillInBags(item) or item:IsLocked() then
        DBL:Release(item)
        return
      end

      -- Destroy item
      PickupContainerItem(item.Bag, item.Slot)
      DeleteCursorItem()
      ClearCursor() -- Clear cursor in case any issues occurred

      -- Notify confirmer
      Confirmer:Queue("Destroyer", item)
    end
  end

  -- Starts the destroying items process.
  function Destroyer:StartDestroyingItems()
    assert(currentState == states.Destroying)
    interval = 0
    self.OnUpdate = destroyItems_OnUpdate
  end

  -- Cancels the destroying items process.
  function Destroyer:StopDestroyingItems()
    assert(currentState == states.Destroying)
    self.OnUpdate = nil
    self:StopDestroying()
  end
end

-- ============================================================================
-- Filter Functions
-- ============================================================================

-- Returns true if the specified item is destroyable.
-- @param item - the item to run through the filter
Destroyer.Filter = function(item)
  if -- Ignore item if it is locked, refundable, or not destroyable
    item:IsLocked() or
    Tools:ItemCanBeRefunded(item) or
    not Tools:ItemCanBeDestroyed(item)
  then
    return false
  end

  -- If tooltip not available, ignore item if an option is enabled which
  -- relies on tooltip data
  if not DTL:ScanBagSlot(item.Bag, item.Slot) then
    if
      DB.Profile.DestroyPetsAlreadyCollected or
      DB.Profile.DestroyToysAlreadyCollected
    then
      Destroyer.incompleteTooltips = true
      return false
    end
  end

  local isDestroyableItem = Destroyer:IsDestroyableItem(item)
  return isDestroyableItem
end

-- Returns a boolean value and a reason string based on whether or not Dejunk
-- will destroy the item.
-- @param item - a DethsBagLib item
function Destroyer:IsDestroyableItem(item)
  --[[ Priority
  1. Is it locked?
  2. Is it on the Destroyables list?
    a. Destroy below price?
  3. Are we destroying Inclusions?
    a. Destroy below price?
  4. Are we ignoring Exclusions?
    a. Destroy below price?
  5. Ignore checks
  6. Destroy checks
  ]]

  -- 1
  if item:IsLocked() then
    return false, L.REASON_ITEM_IS_LOCKED_TEXT
  end

  -- 2
  if ListManager:IsOnList("Destroyables", item.ItemID) then
    local destroy, reason = self:IsDestroyBelowPrice(item)
    return destroy, reason or format(L.REASON_ITEM_ON_LIST_TEXT, L.DESTROYABLES_TEXT)
  end

  -- 3
  if DB.Profile.DestroyInclusions and ListManager:IsOnList("Inclusions", item.ItemID) then
    local destroy, reason = self:IsDestroyBelowPrice(item)
    return destroy, reason or L.REASON_DESTROY_INCLUSIONS_TEXT
  end

  -- 4
  if DB.Profile.DestroyIgnoreExclusions and ListManager:IsOnList("Exclusions", item.ItemID) then
    return false, L.REASON_DESTROY_IGNORE_EXCLUSIONS_TEXT
  end

  -- 5
  if DB.Profile.DestroyIgnoreReadable and item.Readable then
    return false, L.REASON_IGNORE_READABLE_TEXT
  end

  -- 6
  if DB.Profile.DestroyPoor and (item.Quality == LE_ITEM_QUALITY_POOR) then
    local destroy, reason = self:IsDestroyBelowPrice(item)
    return destroy, reason or L.REASON_DESTROY_BY_QUALITY_TEXT
  end

  -- These options require tooltip scanning
  if not DTL:ScanBagSlot(item.Bag, item.Slot) then
    if -- Only return false if one of these options is enabled
      DB.Profile.DestroyPetsAlreadyCollected or
      DB.Profile.DestroyToysAlreadyCollected
    then
      Destroyer.incompleteTooltips = true
      return false, "..."
    end
  else -- Tooltip can be scanned
    if self:IsDestroyPetsAlreadyCollected(item) then
      return true, L.REASON_DESTROY_PETS_ALREADY_COLLECTED_TEXT
    elseif self:IsDestroyToysAlreadyCollectedItem(item) then
      return true, L.REASON_DESTROY_TOYS_ALREADY_COLLECTED_TEXT
    end
  end

  -- Default
  return false, L.REASON_ITEM_NOT_FILTERED_TEXT
end

-- Returns true if the item's price is below the max destroy price.
function Destroyer:IsDestroyBelowPrice(item)
  if DB.Profile.DestroyBelowPrice.Enabled and Tools:ItemCanBeSold(item) then
    local maxPrice = DB.Profile.DestroyBelowPrice.Value

    if ((item.Price * item.Quantity) >= maxPrice) then
      return false, L.REASON_DESTROY_IS_NOT_BELOW_PRICE_TEXT:format(GetCoinTextureString(maxPrice))
    else
      return true, L.REASON_DESTROY_IS_BELOW_PRICE_TEXT:format(GetCoinTextureString(maxPrice))
    end
  end

  return true
end

do -- DestroyPetsAlreadyCollected
  -- "Collected (%d/%d)" -> "Collected (.*)"
  local ITEM_PET_KNOWN_CAPTURE = ITEM_PET_KNOWN:gsub("%%d/%%d", ".*")

  function Destroyer:IsDestroyPetsAlreadyCollected(item)
    if not DB.Profile.DestroyPetsAlreadyCollected or not item.NoValue then return false end
    if not (item.SubClass == Consts.COMPANION_SUBCLASS) then return false end
    return DTL:IsSoulbound() and (not not DTL:Match(false, ITEM_PET_KNOWN_CAPTURE))
  end
end

do -- DestroyToysAlreadyCollected
  local PlayerHasToy = PlayerHasToy

  function Destroyer:IsDestroyToysAlreadyCollectedItem(item)
    if not DB.Profile.DestroyToysAlreadyCollected or not item.NoValue then return false end
    return PlayerHasToy(item.ItemID) and DTL:IsSoulbound()
  end
end