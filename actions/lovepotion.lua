local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local LovePotion = Class(function(self)
   self.activateTime = love.timer.getTime() + 10 -- Disable for first 10 seconds.
   self.image = love.graphics.newImage("assets/images/LovePotion_icon.png")
end)

function LovePotion:activate()
   self.activateTime = love.timer.getTime()
end

function LovePotion:enabled()
   return (love.timer.getTime() - self.activateTime) > Constants.LOVE_POTION_COOLDOWN
end

-- Center is ignored in favor of mouse position
function LovePotion:drawEffectiveArea(center)
   local x,y = love.mouse.getPosition()

   local oldr,oldg,oldb,olda = love.graphics.getColor()
   local areaColor = Constants.EFFECTIVE_AREA_COLOR
   love.graphics.setColor(areaColor.r,areaColor.g,areaColor.b,areaColor.a)
   love.graphics.circle("fill",x,y,Constants.LOVE_POTION_EFFECTIVE_RADIUS)
   love.graphics.setColor(oldr,oldg,oldb,olda)
end

-- Center is ignored in favor of mouse position
function LovePotion:getAffectedSaddies(center,saddies)
   local affectedSaddies = {}

   local mousex,mousey = love.mouse.getPosition()

   for i, saddie in ipairs(saddies) do
      local saddieCenter = saddie:getPosition()
      local saddieRect = {left = saddieCenter.x - Constants.SADDIE_WIDTH,
                          right = saddieCenter.x,
                          top = saddieCenter.y - Constants.SADDIE_HEIGHT / 2,
                          bottom = saddieCenter.y + Constants.SADDIE_HEIGHT / 2}
      saddieRect.width = saddieRect.right - saddieRect.left;
      saddieRect.height = saddieRect.bottom - saddieRect.top;
      
      if (LovePotion:intersects(Vector(mousex,mousey), saddieRect) == true) then
         table.insert(affectedSaddies, saddie);
      end
   end

   return affectedSaddies
end

function LovePotion:intersects(circleCenter, rect)
   local r = Constants.LOVE_POTION_EFFECTIVE_RADIUS
   --This is a monumentally stupid hack because there's a bad offset
   circleDistance = Vector(math.abs((circleCenter.x - r/2) - rect.left + (rect.right-rect.left)*2), math.abs((circleCenter.y - r/2) - rect.top + (rect.bottom-rect.top)*0.5))

   if (circleDistance.x > (rect.width / 2 + r)) then return false end
   if (circleDistance.y > (rect.height / 2 + r)) then return false end
   if (circleDistance.x <= (rect.width / 2)) then return true end
   if (circleDistance.y <= (rect.height / 2)) then return true end

   cornerDistance_sq = (circleDistance.x - rect.width / 2) ^ 2 + (circleDistance.y - rect.height / 2) ^2
   return (cornerDistance_sq <= (r ^ 2))
end

return LovePotion
