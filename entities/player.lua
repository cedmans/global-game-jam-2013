local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local playerImage = love.graphics.newImage("assets/images/avatarside_frame1.png")

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

   self.position.x = math.max(math.min(self.position.x, Constants.MAX_X), Constants.MIN_X)
end

function Player:moveUp(amount)
   self.position.y = self.position.y - amount

   self.position.y = math.max(math.min(self.position.y, Constants.MAX_Y), Constants.MIN_Y)
end

function Player:draw(dt)
   love.graphics.draw(playerImage, self.position.x, self.position.y)
end

return Player
