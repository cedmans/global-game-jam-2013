local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Toolbar = Class(function(self)
   self.active = false
   self.position = Vector(0, 0)
   self.numberItems = 0
end)

function Toolbar:draw(items)
   local percentage
   local oldr, oldg, oldb, olda = love.graphics.getColor()

   for i, item in ipairs(items) do
      love.graphics.draw(
         item.image,
         self.position.x + (Constants.TOOLBAR_ITEM_WIDTH * (i-1)),
         self.position.y)
      percentage = item:percentageCooledDown()
      if percentage <= 1 then
         percentage = math.max(percentage, 0)
         love.graphics.setColor(Constants.COOLDOWN_COLORS)
         love.graphics.rectangle(
            'fill',
            self.position.x + (Constants.TOOLBAR_ITEM_WIDTH * (i-1)),
            self.position.y,
            Constants.TOOLBAR_ITEM_WIDTH,
            Constants.TOOLBAR_ITEM_HEIGHT * (1 - percentage)
         )
         love.graphics.setColor(oldr,oldg,oldb,olda)
      end
   end
end


return Toolbar
