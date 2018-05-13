-- OptionsFrame: a customized DFL scroll frame for displaying options.

local AddonName, Addon = ...

-- Lib
local L = Addon.Libs.L
local DFL = Addon.Libs.DFL

-- Addon
local OptionsFrame = Addon.Objects.OptionsFrame

-- ============================================================================
-- Creation Function
-- ============================================================================

-- Creates and returns a Dejunk options frame.
function OptionsFrame:Create(parent, title)
  local frame = DFL.Frame:Create(parent,
    DFL.Alignments.TOP, DFL.Directions.DOWN)
  frame:SetSpacing(DFL:Padding(0.5))

  -- Title
  local titleFS = DFL.FontString:Create(frame, title)
  -- titleFS:SetColors(Colors.LabelText)
  frame:Add(titleFS)

  -- Scroll frame
  local sf = DFL.SliderScrollFrame:Create(frame)
  -- sf:SetColors(Colors.ScrollFrame, {
  --   Colors.Slider,
  --   Colors.SliderThumb,
  --   Colors.SliderThumbHi
  -- })
  sf._scrollFrame._scrollChild:SetSpacing(DFL:Padding())
  sf:SetMinHeight(100)
  frame._scrollFrame = sf
  frame:Add(sf)

  -- Mixins
  DFL:AddMixins(frame, self.Functions)
  
  return frame
end

-- ============================================================================
-- Creation Function
-- ============================================================================

do
  local Functions = OptionsFrame.Functions

  function Functions:CreateHeading(text)
    local frame = DFL.Frame:Create(parent,
      DFL.Alignments.LEFT, DFL.Directions.DOWN)
   frame:SetSpacing(DFL:Padding(0.5))

    -- Heading font string
   frame:Add(DFL.FontString:Create(frame, text))
    
    -- Heading options container
    local heading = DFL.Frame:Create(frame)
    heading:SetDirection(DFL.Directions.DOWN)
    heading:SetSpacing(DFL:Padding(0.5))
    
   frame:Add(heading)

    self._scrollFrame:Add(frame)

    return heading
  end

  function Functions:OnSetWidth(width)
    self._scrollFrame:SetMinWidth(width)
    self._scrollFrame:Resize()
  end
end
