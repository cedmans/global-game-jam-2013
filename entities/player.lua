local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local staticPlayerImage =
   love.graphics.newImage("assets/images/avatarside_frameidle.png")
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
   self.previousPosition = self.position
   self.targetpos = Vector(400, 400)
end)

function Player:update(dt)
   self.previousPosition = self.position
   -- equals() is a little bit fuzzy, so this allows us to avoid jitter.
   if not self.position:equals(self.targetpos) then
      self.position = self.position + (self.targetpos - self.position):normalized() * Constants.PLAYER_SPEED * dt
   end
end

function Player:draw(time)
   local image
   if self.position:equals(self.previousPosition) then
      image = staticPlayerImage
   else
      image = playerImages[math.floor(time * 5) % 8 + 1]
   end

   love.graphics.draw(image, self.position.x - Constants.PLAYER_WIDTH/2,
    self.position.y - Constants.PLAYER_HEIGHT/2)
end

function Player:getPosition()
   return self.position
end

return Player
