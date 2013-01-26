local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local playerImages = {
   love.graphics.newImage("assets/images/avatarside_frame1.png"),
   love.graphics.newImage("assets/images/avatarside_frame2.png"),
   love.graphics.newImage("assets/images/avatarside_frame3.png"),
   love.graphics.newImage("assets/images/avatarside_frame4.png"),
   love.graphics.newImage("assets/images/avatarside_frame5.png"),
   love.graphics.newImage("assets/images/avatarside_frame6.png"),
   love.graphics.newImage("assets/images/avatarside_frame7.png"),
   love.graphics.newImage("assets/images/avatarside_frame8.png")
}

local Player = Class(function(self)
   self.position = Vector(400, 400)
   self.targetpos = Vector(400, 400)
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

   self.position = self.position + (self.targetpos - self.position):normalized() * 100 * dt
end

function Player:draw(time)
   local image = playerImages[math.floor(time * 5) % 8 + 1]

   love.graphics.draw(image, self.position.x - Constants.PLAYER_WIDTH/2,
    self.position.y - Constants.PLAYER_HEIGHT/2)
end

return Player
