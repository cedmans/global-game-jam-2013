local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Collider = require "hardoncollider"
local Shapes = require "hardoncollider.shapes"

local Wave = Class(function(self)
   self.activateTime = 0
end)

function Wave:activate()
   self.activateTime = love.timer.getTime()
end

function Wave:enabled()
   return (love.timer.getTime() - self.activateTime) > Constants.WAVE_COOLDOWN
end

function Wave:drawEffectiveArea(center)
   local oldr,oldg,oldb,olda = love.graphics.getColor()
   local areaColor = Constants.EFFECTIVE_AREA_COLOR
   love.graphics.setColor(areaColor.r,areaColor.g,areaColor.b,areaColor.a)
   local angle = player:getMouseAngle()
   local length = Constants.WAVE_EFFECTIVE_DISTANCE
   local x2 = math.cos(angle-Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.x
   local y2 = -math.sin(angle-Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.y
   local x3 = math.cos(angle+Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.x
   local y3 = -math.sin(angle+Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.y
   love.graphics.triangle("fill", center.x, center.y, x2, y2, x3, y3)
   love.graphics.setColor(oldr,oldg,oldb,olda)
end

function Wave:getAffectedSaddies(center, saddies)
   local affectedSaddies = {}

   local angle = player:getMouseAngle()
   local length = Constants.WAVE_EFFECTIVE_DISTANCE
   local x1 = center.x
   local y1 = center.y
   local x2 = math.cos(angle-Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.x
   local y2 = -math.sin(angle-Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.y
   local x3 = math.cos(angle+Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.x
   local y3 = -math.sin(angle+Constants.WAVE_ANGLE_OF_OCCURRENCE * math.pi / 180) * length + center.y

   local playerShape = Shapes.newPolygonShape(x1,y1,x2,y2,x3,y3)

   for i, saddie in ipairs(saddies) do
      local pos = saddie:getPosition()
      
      local sx1 = pos.x - Constants.SADDIE_WIDTH/2
      local sy1 = pos.y - Constants.SADDIE_HEIGHT/2
      local sx2 = pos.x + Constants.SADDIE_WIDTH/2
      local sy2 = pos.y + Constants.SADDIE_HEIGHT/2
      
      local saddieShape = Shapes.newPolygonShape(sx1,sy1,sx2,sy1,sx2,sy2,sx1,sy2)
      
      if playerShape:collidesWith(saddieShape) then
         table.insert(affectedSaddies, saddie)
      end
   end

   return affectedSaddies
end

return Wave
