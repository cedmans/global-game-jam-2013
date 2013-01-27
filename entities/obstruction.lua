local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Obstruction = Class(function(self, position, width, height)
   self.position = position
   self.width = width
   self.height = height
end)

function Obstruction:draw()
   -- Uncomment this to see where the obstructions are, for debugging.
   --love.graphics.rectangle(
   --   "fill",
   --   self.position.x,
   --   self.position.y,
   --   self.width,
   --   self.height)
end

return Obstruction
