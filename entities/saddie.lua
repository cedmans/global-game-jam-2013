local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local saddieImage = love.graphics.newImage("assets/images/saddie.png")

local Saddie = Class(function(self, position)
   self.position = position
   self.direction = false
   self.health = Constants.PERFECT_SADNESS
end)

function Saddie:update(dt)
   local amount = self.direction and 10 or -10
   self:moveUp(amount * dt)
   self:addHealth(Constants.SADDIE_HEALTH_REDUCTION * dt);
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

function Saddie:draw(time)
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()
   love.graphics.draw(saddieImage, self.position.x - Constants.SADDIE_WIDTH/2,
    self.position.y - Constants.SADDIE_HEIGHT/2)

   local red, green, blue = self:calculateSadnessBarColors()
   love.graphics.setColor(red, green, blue)
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

function Saddie:getPosition()
   return self.position
end

-- Changes the directions that this saddie is moving in. Mainly just a
-- dummy function to demonstrate that they are being affected.
function Saddie:changeDirection()
   self.direction = not self.direction
end

-- Make a nice gradient from green to yellow to red, based on the thresholds
-- we've set for warning and critical sadness levels.
--
-- Not the most efficient thing in the world, but it took me a while to figure
-- out the math on it.  Being tired probably didn't help.
-- @author JP
function Saddie:calculateSadnessBarColors()
   local red, green, blue
   local percentage
   -- From 100 to warning:      1
   -- From warning to critical: 1 -> 0
   -- From critical to 0:            0
   -- 0........CRITICAL......WARNING...........100
   --             |--------------|
   if self.health > Constants.WARNING_SADNESS then
      percentage = 1
   elseif self.health > Constants.CRITICAL_SADNESS then
      percentage = Util:percentageOfRange(
         Constants.WARNING_SADNESS,
         self.health,
         Constants.CRITICAL_SADNESS)
   else
      percentage = 0
   end
   green = math.floor(percentage * 255)

   -- From 100 to warning:      0 -> 1
   -- From warning to critical:      1
   -- From critical to 0:            1
   -- 0........CRITICAL......WARNING...........100
   --                           |---------------|
   if self.health > Constants.WARNING_SADNESS then
      -- We use the inverse of the percentage because we're going from 0 to 1.
      percentage = 1 - Util:percentageOfRange(
         Constants.PERFECT_SADNESS,
         self.health,
         Constants.WARNING_SADNESS)
   else
      percentage = 1
   end
   red = math.floor(percentage * 255)

   blue = 0

   return red, green, blue
end

return Saddie
