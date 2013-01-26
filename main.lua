local Constants = require "constants"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"

local counter = 0
local player = {}
local saddies = {}

function love.load()
   reset()
end

function reset()
   startTime = love.timer.getTime()
   timeElapsed = 0

   player = Player()

   saddies = {}

   for i = 1, 5 do
      table.insert(saddies, Saddie(Vector(i * 125, i * 100)))
   end
end

function calcMousePlayerAngle()
   mousedelta = Vector(love.mouse.getX(), love.mouse.getY())
   mousedelta = mousedelta - player.position
   mousedelta.y = - mousedelta.y
   return math.atan2(mousedelta.y, mousedelta.x)
end


function love.update(dt)
   for i, saddie in ipairs(saddies) do
      saddie:update(dt)
      -- There's probably a better way to do this. -JP
      if saddie.health < 0 then
         saddies[i] = nil
      end
   end

   player:update(dt)
   timeElapsed = math.floor(love.timer.getTime() - startTime)
end

function love.draw()
   for i, saddie in ipairs(saddies) do
      saddie:draw()
   end

   player:draw()

   love.graphics.print(timeElapsed, 50, 50)
end

-- x: Mouse x position.
-- y: Mouse y position.
-- button: http://www.love2d.org/wiki/MouseConstant
function love.mousepressed(x, y, button)
   -- For now, reset the game on right-click.
   if button == "r" then
      reset()
   end
end
