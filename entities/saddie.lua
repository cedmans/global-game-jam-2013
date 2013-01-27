local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local Saddie = Class(function(self, position)
   self.image = love.graphics.newImage("assets/images/saddie.png")
   self.heart = love.graphics.newImage("assets/images/heart_whole.png")
   self.position = position
   self.targetpos = position
   self.speed = 0.0
   self.direction = false
   self.health = Constants.PERFECT_SADNESS
   self.isHappy = false
   self.happyDuration = 0
   self.healthIncrease = 0
   self.happinessLoopProgress = 0
end)

function Saddie:update(dt)
   self.position = self.position + (self.targetpos - self.position):normalized() * self.speed * dt
   if self.position.dist(self.position, self.targetpos) < 2 then
      while true do
         dir = math.random()*2*math.pi
         vec = Vector(math.cos(dir), math.sin(dir))
         self.speed = Constants.SADDIE_SPEED*(math.random()+1)
         self.targetpos = self.position + Constants.SADDIE_ROUTE_LEG*vec
         if self.targetpos.x > 0 and self.targetpos.x < Constants.SCREEN_WIDTH and self.targetpos.y > 0 and self.targetpos.y < Constants. SCREEN_HEIGHT then break end
      end
   end
   if (self.happyDuration <= 0) then
      self.happyDuration = 0
      self.isHappy = false
      self.healthIncrease = 0
   end

   if (self.isHappy) then
      self:addHealth(self.healthIncrease * dt)
      self.happyDuration = self.happyDuration - dt
      self.happinessLoopProgress = (self.happinessLoopProgress - dt) %
         Constants.HEART_LOOP_LENGTH
   else
      self:addHealth(Constants.SADDIE_HEALTH_REDUCTION * dt);
   end
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
   if (self.health <= Constants.PERFECT_SADNESS) then
      self.health = self.health + dh
   elseif (self.health > Constants.PERFECT_SADNESS) then
      self.health = Constants.PERFECT_SADNESS
   end
end

function Saddie:giveHappiness(health, duration)
   self.isHappy = true
   self.happyDuration = duration
   self.healthIncrease = health
   self.happinessLoopProgress = Constants.HEART_LOOP_LENGTH
end

function Saddie:draw(time)
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()
   love.graphics.draw(self.image, self.position.x - Constants.SADDIE_WIDTH/2,
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
   
   if self.isHappy then
      self:drawHappiness()
   end
end

-- If you're happy and you know it show the world!
function Saddie:drawHappiness()
   local percentageProgress, opacity, yOffset
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()

   percentageProgress = self.happinessLoopProgress / Constants.HEART_LOOP_LENGTH
   -- Start at full opacity and fade out.
   opacity = percentageProgress * 255
   love.graphics.setColor(r, g, b, opacity)
   -- Move away from the saddie.
   yOffset = (((1 - percentageProgress) * Constants.HEART_REACH)
              + Constants.HEART_OFFSET)
   love.graphics.draw(
      self.heart,
      self.position.x - Constants.SADDIE_WIDTH/2,
      self.position.y - Constants.SADDIE_HEIGHT/2 - yOffset)

   love.graphics.setColor(r, g, b, a)
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
