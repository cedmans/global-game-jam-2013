local Constants = require "constants"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"
local DeadSaddie = require "entities.deadsaddie"
local Mouth = require "entities.mouth"

local counter, player, saddies, deadSaddies, time, startTime, action,
      newSpawnTime

local mouth = {}
local activeItem = {}

function love.load()
   reset()   
   r, g, b, a = love.graphics.getColor()
end

function reset()
   startTime = love.timer.getTime()
   time = 0
   newSpawnTime = nextSpawnTime()
   counter = 0

   player = Player()
   saddies = {}
   deadSaddies = {}

   for i = 1, 5 do
      table.insert(saddies, Saddie(randomPoint(spriteDim)))
   end
   
   action = nil

   mouth = Mouth()
   mouth:toggleActive() --set true
   activeItem = mouth;
end

function calcMousePlayerAngle()
   mousedelta = Vector(love.mouse.getX(), love.mouse.getY())
   mousedelta = mousedelta - player.position
   mousedelta.y = - mousedelta.y
   return math.atan2(mousedelta.y, mousedelta.x)
end


function love.update(dt)
   time = time + dt
   
   addSaddies()

   for i, saddie in ipairs(saddies) do
      saddie:update(dt)
      if saddie.health < 0 then
         table.insert(deadSaddies, DeadSaddie(saddie))
         table.remove(saddies,i)
      end
   end
   for i, saddie in ipairs(deadSaddies) do
      saddie:update(dt)
      if saddie:finishedDying() then
         deadSaddies[i] = nil
      end
   end
   player:update(dt)

   timeElapsed = math.floor(love.timer.getTime() - startTime)
end

function love.draw()
   mouth:drawEffectiveArea(player:getPosition());

   for i, saddie in ipairs(saddies) do
      saddie:draw(time)
   end
   for i, saddie in ipairs(deadSaddies) do
      saddie:draw(time)
   end

   player:draw(time)
   if action ~= nil then
      action.draw(time)
   end

   love.graphics.print(math.floor(time), 50, 50)
end

-- x: Mouse x position.
-- y: Mouse y position.
-- button: http://www.love2d.org/wiki/MouseConstant
function love.mousepressed(x, y, button)
   if button == "r" then
      player.targetpos = Vector(x, y)
      action = nil
   elseif button == "l" then
      affectedSaddies = activeItem:getAffectedSaddies(player:getPosition(), saddies)

      for i, saddie in ipairs(affectedSaddies) do
         saddie:giveHappiness(5, 5)
      end
   end
end

function love.keypressed(key, unicode)
   if(love.keyboard.isDown('c')) then
      table.insert(saddies, Saddie(randomPoint()))
   end
   if key == 'q' then
      -- action = QAction()
   elseif key == 'w' then
      -- action = WAction()
   elseif key == 'e' then
      -- action = EAction()
   elseif key == 'r' then
      -- action = RAction()
      reset()
   end
end

-- Potentially add some number of new saddies, dependent on game conditions.
function addSaddies()
   if time > newSpawnTime then
      -- Simple difficulty scaling dependent on time elapsed.
      for i = 1, math.floor(time / 5) do
         table.insert(saddies, Saddie(randomPoint()))
      end
      newSpawnTime = nextSpawnTime()
   end
end

-- Determine the next time we want to spawn saddies.
function nextSpawnTime()
   return time + 5
end

-- Generic perform action function. We probably want to expand this to do
-- different things depending on our current "item".
function performAction(point)
   local affectedSaddies = getAllSaddiesInRadiusFromPoint(point, 150)

   for i, saddie in ipairs(affectedSaddies) do
      saddie:changeDirection()
   end
end

function randomPoint()
   local randomX,randomY = 0,0
	repeat	  
      randomX = math.random(0,Constants.SCREEN_WIDTH - Constants.PLAYER_WIDTH)
      randomY = math.random(0,Constants.SCREEN_HEIGHT - Constants.PLAYER_HEIGHT)
   until(checkSpawn(randomX,randomY))
   randomVector = Vector.new(randomX,randomY)
   return randomVector
end

function checkSpawn(x,y)
   return (((x-player.position.x)^2+(y-player.position.y)^2)^.5 > Constants.SPAWN_RADIUS) 
   --checks is spawn point farther than [RADIUS]px 
end
