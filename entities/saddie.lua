local Class = require "hump.class"
local Vector = require "hump.vector"

-- TODO: Move to a constants file.
local minX = 0
local maxX = 1024
local minY = 0
local maxY = 720

local saddieImage = love.graphics.newImage("assets/images/saddie.png")

local Saddie = Class(function(self, position)
   self.position = position
end)

function Saddie:update(dt)
   self:moveUp(10 * dt);
end

function Saddie:moveRight(amount)
   self.position.x = self.position.x + amount

   self.position.x = math.max(math.min(self.position.x, maxX), minX)
end

function Saddie:moveUp(amount)
   self.position.y = self.position.y - amount

   self.position.y = math.max(math.min(self.position.y, maxY), minY)
end

function Saddie:draw(dt)
   love.graphics.draw(saddieImage, self.position.x, self.position.y)
end

return Saddie
