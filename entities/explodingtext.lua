local Class = require "hump.class"
local Constants = require "constants"

local ExplodingText = Class(function(self, text)
   self.text = text
   self.progress = math.random(85, 100) / 100
end)

function ExplodingText:update(dt)
   self.progress = self.progress - .01
end

function ExplodingText:draw(time)
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()

   love.graphics.setColor(r, g, b, self.progress * 255)
   love.graphics.print(
      self.text,
      Constants.SCREEN_WIDTH / 2 / 2,
      10, --Constants.SCREEN_HEIGHT / 2,
      0,
      (1 - self.progress) * 20,
      (1 - self.progress) * 20,
      ((1 - self.progress) * 20) / 2)
   
   love.graphics.setColor(r, g, b, a)
end

function ExplodingText:finished()
   return self.progress <= 0
end

return ExplodingText

