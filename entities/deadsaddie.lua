local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local DeadSaddie = Class(function(self, saddie)
   self.image = saddie.image
   self.position = saddie.position
   self.progress = 100
end)

function DeadSaddie:update(dt)
   self.progress = self.progress - 1
end

function DeadSaddie:draw(time)
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()

   love.graphics.setColor(r, g, b, self.progress / 100 * 255)
   love.graphics.draw(self.image, self.position.x - Constants.SADDIE_WIDTH/2,
    self.position.y - Constants.SADDIE_HEIGHT/2)

   love.graphics.setColor(r, g, b, a)
end

function DeadSaddie:finishedDying()
   return self.progress == 0
end

return DeadSaddie

