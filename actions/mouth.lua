local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Mouth = Class(function(self)
   self.duration = Constants.MOUTH_HEALTH_DURATION
   self.health = Constants.MOUTH_HEALTH_EFFECT
   self.activateTime = love.timer.getTime() - Constants.MOUTH_COOLDOWN
   self.image = love.graphics.newImage("assets/images/Mouthtalking_icon.png")
end)

function Mouth:activate()
   self.activateTime = love.timer.getTime()
end

function Mouth:enabled()
   return self:percentageCooledDown() >= 1
end

function Mouth:percentageCooledDown()
   return (love.timer.getTime() - self.activateTime) / Constants.MOUTH_COOLDOWN
end

function Mouth:drawEffectiveArea(center)
   local oldr,oldg,oldb,olda = love.graphics.getColor()
   local areaColor = Constants.EFFECTIVE_AREA_COLOR
   love.graphics.setColor(areaColor.r,areaColor.g,areaColor.b,areaColor.a)
   love.graphics.circle("fill",center.x,center.y,Constants.MOUTH_EFFECTIVE_RADIUS);
   love.graphics.setColor(oldr,oldg,oldb,olda)
end

function Mouth:getAffectedSaddies(center,saddies)
   local affectedSaddies = {}

   for i, saddie in ipairs(saddies) do
      local saddieCenter = saddie:getPosition()
      local saddieRect = {left = saddieCenter.x - Constants.SADDIE_WIDTH,
                          right = saddieCenter.x,
                          top = saddieCenter.y - Constants.SADDIE_HEIGHT / 2,
                          bottom = saddieCenter.y + Constants.SADDIE_HEIGHT / 2}
      saddieRect.width = saddieRect.right - saddieRect.left;
      saddieRect.height = saddieRect.bottom - saddieRect.top;
      
      if (Mouth:intersects(center, saddieRect) == true) then
         table.insert(affectedSaddies, saddie);
      end
   end

   return affectedSaddies;
end

function Mouth:intersects(circleCenter, rect)
   local r = Constants.MOUTH_EFFECTIVE_RADIUS
   circleDistance = Vector(math.abs((circleCenter.x - r/2) - rect.left), math.abs((circleCenter.y - r/2) - rect.top))

   if (circleDistance.x > (rect.width / 2 + r)) then return false end
   if (circleDistance.y > (rect.height / 2 + r)) then return false end
   if (circleDistance.x <= (rect.width / 2)) then return true end
   if (circleDistance.y <= (rect.height / 2)) then return true end

   cornerDistance_sq = (circleDistance.x - rect.width / 2) ^ 2 + (circleDistance.y - rect.height / 2) ^2
   return (cornerDistance_sq <= (r ^ 2))
end

return Mouth
