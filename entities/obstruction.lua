local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local Obstruction = Class(function(self, position)
   self.position = position
end)

function Obstruction:draw()
   -- Store colors for later resetting.
   love.graphics.rectangle(
      "fill",
      self.position.x - Constants.OBS_WIDTH/2,
      self.position.y - Constants.OBS_HEIGHT/2,
      Constants.OBS_WIDTH,
      Constants.OBS_HEIGHT)
end

return Obstruction
