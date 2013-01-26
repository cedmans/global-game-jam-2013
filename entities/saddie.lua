local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local saddieImage = love.graphics.newImage("assets/images/saddie.png")

local Saddie = Class(function(self, position)
   self.position = position
   self.health = 40 -- Reduced for easier testing.  Preferably 100.
   self.direction = false
end)

function Saddie:update(dt)
   local amount = self.direction and 10 or -10
   self:moveUp(amount * dt)
   self:addHealth(Constants.SADDIE_HEALTH_REDUCTION * dt);
   print(self.health);
end

function Saddie:moveRight(amount)
   self.position.x = self.position.x + amount

   self.position.x = math.max(math.min(self.position.x, Constants.MAX_X), Constants.MIN_X)
end

function Saddie:moveUp(amount)
   self.position.y = self.position.y - amount

   self.position.y = math.max(math.min(self.position.y, Constants.MAX_Y), Constants.MIN_Y)
end

function Saddie:addHealth(dh)
   self.health = self.health + dh
end

function Saddie:draw(dt)
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()
   love.graphics.draw(saddieImage, self.position.x - Constants.SADDIE_WIDTH/2,
    self.position.y - Constants.SADDIE_HEIGHT/2)

   if self.health < Constants.CRITICAL_SADNESS then
      love.graphics.setColor(255, 0, 0)
   elseif self.health < Constants.WARNING_SADNESS then
      love.graphics.setColor(255, 255, 0)
   else
      love.graphics.setColor(0, 255, 0)
   end
   love.graphics.rectangle(
      "fill",
      self.position.x - Constants.SADDIE_WIDTH/2,
      self.position.y - Constants.SADNESS_BAR_OFFSET - Constants.SADDIE_HEIGHT/2,
      self.health,
      Constants.SADNESS_BAR_OFFSET)

   love.graphics.setColor(r, g, b, a)
   if self.health < Constants.CRITICAL_SADNESS then
      love.graphics.print(
         math.ceil(self.health),
         self.position.x - Constants.SADNESS_ALERT_OFFSET,
         self.position.y)
   end
end

function Saddie.getPosition()
   return self.position
end

function Saddie.getDimensions()
   --TODO: Get real dimensions
   return Vector.new(0,0)
end

-- Changes the directions that this saddie is moving in. Mainly just a
-- dummy function to demonstrate that they are being affected.
function Saddie:changeDirection()
   self.direction = not self.direction
end

return Saddie
