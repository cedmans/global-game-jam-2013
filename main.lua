local Constants = require "constants"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"

local counter = 0
local player = {}
local saddies = {}
local action = nil
local time = 0
local timeElapsed = 0

function love.load()
   reset()
end

function reset()
   startTime = love.timer.getTime()
   time = 0
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
   time = time + dt

   for i, saddie in ipairs(saddies) do
      saddie:update(dt)
      -- There's probably a better way to do this. -JP
      if saddie.health < 0 then
         saddies[i] = nil
      end
   end

   player:update(dt)
   timeElapsed = math.floor(time)
end

function love.draw()
   for i, saddie in ipairs(saddies) do
      saddie:draw(time)
   end

   player:draw()
   if action != nil then
      action.draw(time)
   end

   love.graphics.print(timeElapsed, 50, 50)
end

-- x: Mouse x position.
-- y: Mouse y position.
-- button: http://www.love2d.org/wiki/MouseConstant
function love.mousepressed(x, y, button)
   -- For now, reset the game on right-click.
   if button == "r" then
      player.targetpos = Vector(x, y)
      action = nil
   elseif button == "l" then
      if action != nil then
         action.perform()
         action = nil
      end
   end
end

function love.keypressed(key, unicode)
   if key == 'q' then
      -- action = QAction()
   elseif key == 'w' then
      -- action = WAction()
   elseif key == 'e' then
      -- action = EAction()
   elseif key == 'r' then
      -- action = RAction()
   end
end

function getAllSaddiesInRadiusFromPoint(point, radius)
   local closeSaddies = {}

   for i, saddie in ipairs(saddies) do
      if point:dist(saddie.position) < radius then
         table.insert(closeSaddies, saddie)
      end
   end

   return closeSaddies
end
