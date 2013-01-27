local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Sound = require "sound"

local HighFive = Class(function(self)
   self.duration = Constants.HIGH_FIVE_HEALTH_DURATION
   self.health = Constants.HIGH_FIVE_HEALTH_EFFECT
   self.activateTime = 0
   self.image = love.graphics.newImage("assets/images/Highfive_icon.png")
end)

function HighFive:activate(affectedSaddies)
   self.activateTime = love.timer.getTime()

   if #affectedSaddies > 0 then
      Sound.highFive()
   end
end

function HighFive:enabled()
   return self:percentageCooledDown() >= 1
end

function HighFive:percentageCooledDown()
   return (love.timer.getTime() - self.activateTime) / Constants.HIGH_FIVE_COOLDOWN
end

function HighFive:drawEffectiveArea(center)
   local oldr,oldg,oldb,olda = love.graphics.getColor()
   local areaColor = Constants.EFFECTIVE_AREA_COLOR
   love.graphics.setColor(areaColor.r,areaColor.g,areaColor.b,areaColor.a)
   love.graphics.circle("fill", center.x, center.y, Constants.HIGH_FIVE_EFFECTIVE_RADIUS);
   love.graphics.setColor(oldr,oldg,oldb,olda)
end

function HighFive:getAffectedSaddies(center,saddies)
   local closestSaddieDistance = 4523234234 -- TODO: INT_MAX?
   local closestSaddie = {}

   for i, saddie in ipairs(saddies) do
      local distance = center:dist(saddie:getPosition())

      if distance < closestSaddieDistance then
         closestSaddieDistance = distance
         closestSaddie = saddie
      end
   end

   if closestSaddieDistance < Constants.HIGH_FIVE_EFFECTIVE_RADIUS then
      return {closestSaddie}
   else
      return {}
   end
end

return HighFive
