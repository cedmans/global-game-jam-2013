local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local toolURIs = {mouth = love.graphics.newImage("assets/images/Mouthtalking_icon.png"),
                  wave = love.graphics.newImage("assets/images/Wave_icon.png"),
                  lovepotion = love.graphics.newImage("assets/images/lovePotion.png")}

local Toolbar = Class(function(self)
   self.active = false
   self.position = Vector(0, 0)
   self.numberItems = 0
end)

function Toolbar:draw()
   local oldr, oldg, oldb, olda = love.graphics.getColor()

   love.graphics.draw(toolURIs["mouth"], self.position.x, self.position.y)
   love.graphics.setColor(0,102,0,255)
   love.graphics.printf("1", self.position.x, self.position.y + 3, Constants.TOOLBAR_ITEM_WIDTH, 'center')
   love.graphics.setColor(oldr,oldg,oldb,olda)

   love.graphics.draw(toolURIs["wave"], self.position.x+Constants.TOOLBAR_ITEM_WIDTH, self.position.y)
   love.graphics.setColor(0,102,0,255)
   love.graphics.printf("2", self.position.x + Constants.TOOLBAR_ITEM_WIDTH, self.position.y + 3, Constants.TOOLBAR_ITEM_WIDTH, 'center')
   love.graphics.setColor(oldr,oldg,oldb,olda)

   love.graphics.draw(toolURIs["lovepotion"], self.position.x+Constants.TOOLBAR_ITEM_WIDTH*2, self.position.y)
   love.graphics.setColor(0,102,0,255)
   love.graphics.printf("3", self.position.x + Constants.TOOLBAR_ITEM_WIDTH*2, self.position.y + 3, Constants.TOOLBAR_ITEM_WIDTH, 'center')
   love.graphics.setColor(oldr,oldg,oldb,olda)
end


return Toolbar
