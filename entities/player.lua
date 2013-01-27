local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local staticPlayerImage =
   love.graphics.newImage("assets/images/avatarside_frameidle.png")
local playerImages = {
   left = {
      love.graphics.newImage("assets/images/avatarside_frame1.png"),
      love.graphics.newImage("assets/images/avatarside_frame2.png"),
      love.graphics.newImage("assets/images/avatarside_frame3.png"),
      love.graphics.newImage("assets/images/avatarside_frame4.png"),
      love.graphics.newImage("assets/images/avatarside_frame5.png"),
      love.graphics.newImage("assets/images/avatarside_frame6.png"),
      love.graphics.newImage("assets/images/avatarside_frame7.png"),
      love.graphics.newImage("assets/images/avatarside_frame8.png")
   },
   right = {
      love.graphics.newImage("assets/images/avatarside_frame1.png"),
      love.graphics.newImage("assets/images/avatarside_frame2.png"),
      love.graphics.newImage("assets/images/avatarside_frame3.png"),
      love.graphics.newImage("assets/images/avatarside_frame4.png"),
      love.graphics.newImage("assets/images/avatarside_frame5.png"),
      love.graphics.newImage("assets/images/avatarside_frame6.png"),
      love.graphics.newImage("assets/images/avatarside_frame7.png"),
      love.graphics.newImage("assets/images/avatarside_frame8.png")
   },
   up = {
      love.graphics.newImage("assets/images/avatarbot_frame1.png"),
      love.graphics.newImage("assets/images/avatarbot_frame2.png"),
      love.graphics.newImage("assets/images/avatarbot_frame3.png"),
      love.graphics.newImage("assets/images/avatarbot_frame4.png"),
      love.graphics.newImage("assets/images/avatarbot_frame5.png"),
      love.graphics.newImage("assets/images/avatarbot_frame6.png"),
      love.graphics.newImage("assets/images/avatarbot_frame7.png"),
      love.graphics.newImage("assets/images/avatarbot_frame8.png")
   },
   down = {
      love.graphics.newImage("assets/images/avatartop_frame1.png"),
      love.graphics.newImage("assets/images/avatartop_frame2.png"),
      love.graphics.newImage("assets/images/avatartop_frame3.png"),
      love.graphics.newImage("assets/images/avatartop_frame4.png"),
      love.graphics.newImage("assets/images/avatartop_frame5.png"),
      love.graphics.newImage("assets/images/avatartop_frame6.png"),
      love.graphics.newImage("assets/images/avatartop_frame7.png"),
      love.graphics.newImage("assets/images/avatartop_frame8.png")
   }
}

local Player = Class(function(self)
   self.position = Vector(400, 400)
   self.previousPosition = self.position
   self.targetpos = Vector(400, 400)
   self.direction = "down"

end)

function Player:update(dt)
   for k, i in ipairs(playerImages) do
      print('k = '..k..'; i = '..i)
   end
   self.previousPosition = self.position
   -- equals() is a little bit fuzzy, so this allows us to avoid jitter.
   if not self.position:equals(self.targetpos) then
      self.position = self.position + (self.targetpos - self.position):normalized() * Constants.PLAYER_SPEED * dt
   end

   obstructed = false
   for i, obs in ipairs(obstructions) do
      if math.abs(self.position.x-obs.position.x) < (Constants.PLAYER_WIDTH+obs.width)/2 and math.abs(self.position.y-obs.position.y) < (Constants.PLAYER_HEIGHT+obs.height)/2 then
         obstructed = true
      end
   end
   if obstructed then
      self.targetpos = self.position
   end
end

function Player:getMouseAngle()
   mouseDelta = Vector(love.mouse.getX(), love.mouse.getY())
   mouseDelta = mouseDelta - self.position
   mouseDelta.y = - mouseDelta.y
   return math.atan2(mouseDelta.y, mouseDelta.x)
end

function Player:draw(time)
   local image
   if self.position:equals(self.previousPosition) then
      image = staticPlayerImage
   else
      image = playerImages[self.direction][math.floor(time * 5) % 8 + 1]
   end

   love.graphics.draw(image, self.position.x - Constants.PLAYER_WIDTH/2,
    self.position.y - Constants.PLAYER_HEIGHT/2)
end

function Player:getPosition()
   return self.position
end

function Player:setDirection(direction)
   self.direction = direction
end

return Player
