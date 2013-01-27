local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local DeadSaddie = Class(function(self, saddie)
   self.image = saddie.image
   self.leftPiece = love.graphics.newImage("assets/images/heart_left.png")
   self.rightPiece = love.graphics.newImage("assets/images/heart_right.png")
   self.position = saddie.position
   self.progress = 1
end)

function DeadSaddie:update(dt)
   self.progress = self.progress - .01
end

function DeadSaddie:draw(time)
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()

   love.graphics.setColor(r, g, b, self.progress * 255)
   love.graphics.draw(self.image, self.position.x - Constants.SADDIE_WIDTH/2,
    self.position.y - Constants.SADDIE_HEIGHT/2)
   
   self:drawBrokenHearts()

   love.graphics.setColor(r, g, b, a)
end

function DeadSaddie:drawBrokenHearts()
   -- Middle
   xOffset = 5
   yOffset = (((1 - self.progress) * Constants.HEART_REACH)
              + Constants.HEART_OFFSET)
   self:drawHeart(self.leftPiece, xOffset, yOffset)
   xOffset = -xOffset
   self:drawHeart(self.rightPiece, xOffset, yOffset)
end

function DeadSaddie:drawHeart(heart, xOffset, yOffset)
   love.graphics.draw(
      heart,
      self.position.x - Constants.SADDIE_WIDTH/2 - xOffset,
      self.position.y - Constants.SADDIE_HEIGHT/2 - yOffset)
end

function DeadSaddie:finishedDying()
   return self.progress <= 0
end

return DeadSaddie

