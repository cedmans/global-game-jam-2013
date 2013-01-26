local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local playerImage = love.graphics.newImage("assets/images/avatarside_frame1.png")

local Player = Class(function(self)
   self.position = Vector(400, 400)
   self.targetpos = Vector(400, 400)
end)

function Player:update(dt)
   self.position = self.position + (self.targetpos - self.position):normalized() * 100 * dt
end

function Player:draw(dt)
   love.graphics.draw(playerImage, self.position.x, self.position.y)
end

return Player
