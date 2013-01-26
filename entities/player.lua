local Class = require "hump.class"
local Vector = require "hump.vector"

local Player = Class(function(self)
   self.position = Vector(400, 400)
end)

function Player:update(dt)
   if (love.keyboard.isDown('w')) then
      self:moveUp(dt * 200)
   end

   if (love.keyboard.isDown('s')) then
      self:moveUp(-dt * 200)
   end

   if (love.keyboard.isDown('a')) then
      self:moveRight(-dt * 200)
   end

   if (love.keyboard.isDown('d')) then
      self:moveRight(dt * 200)
   end
end

function Player:moveRight(amount)
   self.position.x = self.position.x + amount
end

function Player:moveUp(amount)
   self.position.y = self.position.y - amount
end

function Player:draw(dt)
   love.graphics.print("Player", self.position.x, self.position.y)
end

return Player
