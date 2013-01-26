local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local saddieImage = love.graphics.newImage("assets/images/saddie.png")

local Saddie = Class(function(self, position)
   self.position = position
   self.health = 100
end)

function Saddie:update(dt)
   self:moveUp(10 * dt);
   self:addHealth(-5 * dt);
end

function Saddie:moveRight(amount)
   self.position.x = self.position.x + amount

   self.position.x = math.max(math.min(self.position.x, Constants.MAX_X), Constants.MIN_X)
end

function Saddie:moveUp(amount)
   self.position.y = self.position.y - amount

   self.position.y = math.max(math.min(self.position.y, Constants.MAX_Y), Constants.MIN_Y)
end

function Saddie:addHealth(dh)
   self.health = self.health + dh
end

function Saddie:draw(dt)
   love.graphics.draw(saddieImage, self.position.x, self.position.y)
   love.graphics.rectangle(
      "fill",
      self.position.x,
      self.position.y - Constants.SADNESS_BAR_OFFSET,
      self.health,
      Constants.SADNESS_BAR_OFFSET)
end

return Saddie
