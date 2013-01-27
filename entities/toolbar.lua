local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Toolbar = Class(function(self)
   self.active = false
   self.position = Vector(0, 0)
   self.numberItems = 0
end)

function Toolbar:draw(items, activeItem)
   local xPos, yPos, percentage
   local oldr, oldg, oldb, olda = love.graphics.getColor()

   for i, item in ipairs(items) do
      if i ~= activeItem then
         love.graphics.setColor(100, 100, 100, olda)
      end
      xPos = (self.position.x
             + (Constants.TOOLBAR_ITEM_WIDTH * ((i-1) % 2)))
      yPos = (self.position.y
             + (Constants.TOOLBAR_ITEM_HEIGHT * math.floor((i-1) / 2)))
      love.graphics.draw(
         item.image,
         xPos,
         yPos)

      percentage = item:percentageCooledDown()
      if percentage <= 1 then
         percentage = math.max(percentage, 0)
         love.graphics.setColor(Constants.COOLDOWN_COLORS)
         love.graphics.rectangle(
            'fill',
            xPos,
            yPos,
            Constants.TOOLBAR_ITEM_WIDTH,
            Constants.TOOLBAR_ITEM_HEIGHT * (1 - percentage)
         )
      end
      love.graphics.setColor(oldr,oldg,oldb,olda)
   end
end


return Toolbar
