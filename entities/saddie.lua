local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local staticSaddieImage =
   love.graphics.newImage("assets/images/npcside_frameidle.png")
local saddieImages = {
   left = {
      love.graphics.newImage("assets/images/npcside_frame1.png"),
      love.graphics.newImage("assets/images/npcside_frame2.png"),
      love.graphics.newImage("assets/images/npcside_frame3.png"),
      love.graphics.newImage("assets/images/npcside_frame4.png"),
      love.graphics.newImage("assets/images/npcside_frame5.png"),
      love.graphics.newImage("assets/images/npcside_frame6.png"),
      love.graphics.newImage("assets/images/npcside_frame7.png"),
      love.graphics.newImage("assets/images/npcside_frame8.png")
   },
   right = {
      love.graphics.newImage("assets/images/npcside_frame1.png"),
      love.graphics.newImage("assets/images/npcside_frame2.png"),
      love.graphics.newImage("assets/images/npcside_frame3.png"),
      love.graphics.newImage("assets/images/npcside_frame4.png"),
      love.graphics.newImage("assets/images/npcside_frame5.png"),
      love.graphics.newImage("assets/images/npcside_frame6.png"),
      love.graphics.newImage("assets/images/npcside_frame7.png"),
      love.graphics.newImage("assets/images/npcside_frame8.png")
   },
   up = {
      love.graphics.newImage("assets/images/npctop_frame1.png"),
   
   love.graphics.newImage("assets/images/npctop_frame2.png"),
      love.graphics.newImage("assets/images/npctop_frame3.png"),
      love.graphics.newImage("assets/images/npctop_frame4.png"),
      love.graphics.newImage("assets/images/npctop_frame5.png"),
      love.graphics.newImage("assets/images/npctop_frame6.png"),
      love.graphics.newImage("assets/images/npctop_frame7.png"),
      love.graphics.newImage("assets/images/npctop_frame8.png")
   },
   down = {
      love.graphics.newImage("assets/images/npcbot_frame1.png"),
      love.graphics.newImage("assets/images/npcbot_frame2.png"),
      love.graphics.newImage("assets/images/npcbot_frame3.png"),
      love.graphics.newImage("assets/images/npcbot_frame4.png"),
      love.graphics.newImage("assets/images/npcbot_frame5.png"),
      love.graphics.newImage("assets/images/npcbot_frame6.png"),
      love.graphics.newImage("assets/images/npcbot_frame7.png"),
      love.graphics.newImage("assets/images/npcbot_frame8.png")
   }
}

local Saddie = Class(function(self, position)
   self.image = staticSaddieImage
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

   self.directionWord = "left"
end)

function Saddie:update(dt)
   self.position = self.position + (self.targetpos - self.position):normalized() * self.speed * dt
   if self.position.dist(self.position, self.targetpos) < 2 then
      while true do
         dir = math.random()*2*math.pi
         vec = Vector(math.cos(dir), math.sin(dir))
         self.speed = Constants.SADDIE_SPEED*(math.random()+1)
         self.targetpos = self.position + Constants.SADDIE_ROUTE_LEG*vec

         obstructed = false
         for i, obs in ipairs(obstructions) do
            if math.abs(self.targetpos.x-obs.position.x) <
               (Constants.SADDIE_WIDTH+obs.width)/2
            and math.abs(self.targetpos.y-obs.position.y) <
               (Constants.SADDIE_HEIGHT+obs.height)/2 then
               obstructed = true
            end
         end

         if not obstructed and self.targetpos.x > Constants.MIN_X and self.targetpos.x < Constants.MAX_X and self.targetpos.y > Constants.MIN_Y and self.targetpos.y < Constants.MAX_Y then break end
      end
      tgtDelta = self.targetpos - self.position
      tgtDelta.y = - tgtDelta.y
      angle = math.atan2(tgtDelta.y, tgtDelta.x)
      if angle < -math.pi*3/4 then
         self.directionWord = "left"
      elseif angle < -math.pi/4 then
         self.directionWord = "down"
      elseif angle < math.pi/4 then
         self.directionWord = "right"
      elseif angle < math.pi*3/4 then
         self.directionWord = "up"
      else
         self.directionWord = "left"
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
   self.image = saddieImages[self.directionWord][math.floor(time * 5) % 8 + 1]

   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()

   local scaleFactor
   local offset = Vector.new()

   if self.directionWord == "left" then
      scaleFactor = -1
      offset.x = Constants.SADDIE_WIDTH
   else
      scaleFactor = 1
      offset.x = 0
   end

   offset.y = 0

   love.graphics.draw(self.image, self.position.x - Constants.SADDIE_WIDTH/2,
    self.position.y - Constants.SADDIE_HEIGHT/2, 0, scaleFactor, 1, offset.x, offset.y)

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
   local percentageProgress, opacity, xOffset, yOffset
   -- Store colors for later resetting.
   r, g, b, a = love.graphics.getColor()

   percentageProgress = self.happinessLoopProgress / Constants.HEART_LOOP_LENGTH
   -- Start at full opacity and fade out.
   opacity = percentageProgress * 255
   love.graphics.setColor(r, g, b, opacity)

   -- Middle heart
   xOffset = 0
   yOffset = (((1 - percentageProgress) * Constants.HEART_REACH)
              + Constants.HEART_OFFSET)
   self:drawHeart(xOffset, yOffset)

   -- Left heart
   xOffset = (1 - math.sin(percentageProgress)) * Constants.HEART_REACH
   yOffset = math.cos(percentageProgress) * Constants.HEART_REACH
   self:drawHeart(xOffset, yOffset)

   -- Right heart
   xOffset = -xOffset
   self:drawHeart(xOffset, yOffset)

   love.graphics.setColor(r, g, b, a)
end

function Saddie:drawHeart(xOffset, yOffset)
   love.graphics.draw(
      self.heart,
      self.position.x - Constants.SADDIE_WIDTH/2 - xOffset,
      self.position.y - Constants.SADDIE_HEIGHT/2 - yOffset)
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
      percentage = Util.percentageOfRange(
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
      percentage = 1 - Util.percentageOfRange(
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
