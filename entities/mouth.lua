local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Mouth = Class(function(self)
   self.active = false
end)

function Mouth:toggleActive()
   self.active = not self.active
end

function Mouth:drawEffectiveArea(center)
   if (self.active) then
      local oldr,oldg,oldb,olda = love.graphics.getColor()
      local areaColor = Constants.EFFECTIVE_AREA_COLOR
      love.graphics.setColor(areaColor.r,areaColor.g,areaColor.b,areaColor.a)
      love.graphics.circle("fill",center.x,center.y,Constants.MOUTH_EFFECTIVE_RADIUS);
      love.graphics.setColor(oldr,oldg,oldb,olda)
   end
end

function Mouth:getAffectedSaddies(center,saddies)
   local affectedSaddies = {}

   for i, saddie in ipairs(saddies) do
      local saddieCenter = saddie:getPosition()
      local saddieRect = {left = saddieCenter.x - Constants.SADDIE_WIDTH / 2,
                          right = saddieCenter.x + Constants.SADDIE_WIDTH / 2,
                          top = saddieCenter.y - Constants.SADDIE_HEIGHT / 2,
                          bottom = saddieCenter.y + Constants.SADDIE_HEIGHT / 2}
      
      if (intersects(center, saddieRect)) then
         table.insert(affectedSaddies, saddie);
      end
   end

   return affectedSaddies;
end

function intersects(center, saddieRect)
   local r = Constants.MOUTH_EFFECTIVE_RADIUS
   
   local circleDistance = Vector(math.abs((center.x - r/2) - saddieRect.left), math.abs((center.y - r/2) - saddieRect.top));

   if (circleDistance.x > ((saddieRect.right - saddieRect.left) / 2 + r)) then
      return false
   end
   if (circleDistance.y > ((saddieRect.bottom-saddieRect.top) / 2 + r)) then
      return false
   end
   if (circleDistance.x <= ((saddieRect.right - saddieRect.left) / 2)) then
      return true
   end
   if (circleDistance.y <= ((saddieRect.bottom-saddieRect.top) / 2)) then
      return true
   end

   cornerDistance_sq = (circleDistance.x - (saddieRect.right - saddieRect.left) / 2) ^ 2 +
                       (circleDistance.y - (saddieRect.bottom-saddieRect.top) / 2) ^ 2;

   return (cornerDistance_sq <= (r ^ 2));
end

return Mouth
