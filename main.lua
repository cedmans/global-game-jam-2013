local Constants = require "constants"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"
local DeadSaddie = require "entities.deadsaddie"
local Toolbar = require 'entities.toolbar'
local Mouth = require "entities.mouth"

local Hud = require "entities.hud"


local counter = 0
saddies = {}
local player = {}
local deadSaddies = {}
local action = nil
local time = 0
local startTime
local hud = {}


player = {}

local counter, saddies, deadSaddies, time, startTime, action,
      newSpawnTime, lives, gameEnded, toolbar

      

local mouth = {}
local activeItem = {}

function love.load()
   reset()   
   r, g, b, a = love.graphics.getColor()
end

function reset()
   gameEnded = false
   startTime = love.timer.getTime()
   time = 0
   newSpawnTime = nextSpawnTime()
   counter = 0
   lives = 1

   player = Player()

   hud = Hud()



   saddies = {}
   deadSaddies = {}

   for i = 1, 5 do
      table.insert(saddies, Saddie(randomPoint(spriteDim)))
   end
   
   action = nil

   mouth = Mouth()
   mouth:toggleActive() --set true
   activeItem = mouth;

   toolbar = Toolbar()
end

function endGame()
   gameEnded = true
   saddies = {}
   deadSaddies = {}
end

function calcMousePlayerAngle()
   mousedelta = Vector(love.mouse.getX(), love.mouse.getY())
   mousedelta = mousedelta - player.position
   mousedelta.y = - mousedelta.y
   return math.atan2(mousedelta.y, mousedelta.x)
end


function love.update(dt)
   -- Stop doing most things when the game is done.
   if gameEnded then
      return
   end

   time = time + dt
   
   addSaddies()

   for i, saddie in ipairs(saddies) do
      saddie:update(dt)
      if saddie.health < 0 then
         table.insert(deadSaddies, DeadSaddie(saddie))
         table.remove(saddies,i)
         lives = lives - 1
      end
   end
   for i, saddie in ipairs(deadSaddies) do
      saddie:update(dt)
      if saddie:finishedDying() then
         deadSaddies[i] = nil
      end
   end
   player:update(dt)
   
   if math.floor(lives) <= 0 then
      endGame()
   end

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
   if (not gameEnded) then
      hud:draw(time)
   elseif (gameEnded) then
      love.graphics.print("FINAL SCORE: " .. hud:getScore(),870,20)
   end
   if action ~= nil then
      action.draw(time)
   end
   
   if gameEnded then
      love.graphics.print(
         "Game Over",
         Constants.SCREEN_WIDTH / 2,
         Constants.SCREEN_HEIGHT / 2)
   end

   toolbar:draw()


   love.graphics.print(math.floor(time), 50, 50)
   love.graphics.print(math.floor(lives), 50, 70)

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
      lives = lives + 0.25
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
   --may have to expand to prevent spawning on obstacles
end

 



