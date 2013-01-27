local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local toolURIs = {
   mouth = love.graphics.newImage("assets/images/Mouthtalking_icon.png"),
   wave = love.graphics.newImage("assets/images/Wave_icon.png"),
   lovepotion = love.graphics.newImage("assets/images/LovePotion_icon.png"),
}

local Toolbar = Class(function(self)
   self.active = false
   self.position = Vector(0, 0)
   self.numberItems = 0
end)

function Toolbar:draw()
   local oldr, oldg, oldb, olda = love.graphics.getColor()

   love.graphics.draw(toolURIs["mouth"], self.position.x, self.position.y)
   love.graphics.setColor(0,102,0,255)
   love.graphics.setColor(oldr,oldg,oldb,olda)

   love.graphics.draw(toolURIs["wave"], self.position.x+Constants.TOOLBAR_ITEM_WIDTH, self.position.y)
   love.graphics.setColor(0,102,0,255)
   love.graphics.setColor(oldr,oldg,oldb,olda)

   if timeElapsed > 10 then
      love.graphics.draw(toolURIs["lovepotion"], self.position.x+Constants.TOOLBAR_ITEM_WIDTH*2, self.position.y)
      love.graphics.setColor(0,102,0,255)
      love.graphics.setColor(oldr,oldg,oldb,olda)
   end
end


return Toolbar
