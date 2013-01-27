local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Wave = Class(function(self)
end)

function Wave:drawEffectiveArea(center)
   local oldr,oldg,oldb,olda = love.graphics.getColor()
   local areaColor = Constants.EFFECTIVE_AREA_COLOR
   love.graphics.setColor(areaColor.r,areaColor.g,areaColor.b,areaColor.a)
   local angle = player:getMouseAngle()
   local length = Constants.WAVE_EFFECTIVE_DISTANCE
   local x2 = math.cos(angle) * length + center.x
   local y2 = -math.sin(angle) * length + center.y
   love.graphics.line(center.x, center.y, x2, y2)
   love.graphics.setColor(oldr,oldg,oldb,olda)
end

return Wave
