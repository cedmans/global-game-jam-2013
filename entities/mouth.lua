local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local effectiveRadius = 50

local Mouth = Class(function(self)
   self.active = false
end)

function Mouth:toggleActive()
   self.active = not self.active
end

function Mouth:drawEffectiveArea(center)
   if (self.active) then
      local r,g,b,a = love.graphics.getColor()
      love.graphics.setColor(0,102,0,100)
      love.graphics.circle("fill",center.x,center.y,50);
      love.graphics.setColor(r,g,b,a)
   end
end

function Mouth:getAffectedSaddies(center,saddies)
   local affectedSaddies = {}

   for i, saddie in ipairs(saddies) do
      local saddieCenter = Saddie.getPosition()
      local saddieDimensions = Saddie.getDimensions()
      local saddiePoint = {}

      -- quadrant checks for corners
      if (saddie.x < center.x) then
         if (saddie.y < center.y) then
            saddiePoint = Vector.new(saddieCenter.x + (saddieDimensions.x / 2), saddieCenter.y + (saddieDimensions.y / 2))
         else
            saddiePoint = Vector.new(saddieCenter.x + (saddieDimensions.x / 2), saddieCenter.y - (saddieDimensions.y / 2))
         end
      else
         if (saddie.y < center.y) then
            saddiePoint = Vector.new(saddieCenter.x - (saddieDimensions.x / 2), saddieCenter.y + (saddieDimensions.y / 2))
         else
            saddiePoint = Vector.new(saddieCenter.x - (saddieDimensions.x / 2), saddieCenter.y - (saddieDimensions.y / 2))
         end
      end
      
      local distance = math.sqrt((center.x - saddiePoint.x) ^ 2 + (center.y - saddiePoint.y) ^ 2)

      if (distance <= effectiveRadius) then
         table.insert(affectedSaddies, saddie);
      end
   end
end

return Mouth
