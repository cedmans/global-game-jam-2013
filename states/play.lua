local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Sound = require "sound"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"
local DeadSaddie = require "entities.deadsaddie"
local Obstruction = require "entities.obstruction"
local Toolbar = require 'entities.toolbar'
local Mouth = require "entities.mouth"
local Wave = require "entities.wave"
local Hud = require "entities.hud"

local counter = 0
obstructions = {}
saddies = {}
local deadSaddies = {}
local action = nil
local time = 0
local startTime
local hud = {}

player = {}
lives = {}

local counter, saddies, deadSaddies, time, startTime, action,
      newSpawnTime, toolbar

local mouth = {}
local wave = {}
local activeItem = {}
local background = love.graphics.newImage("assets/images/Background_city.png")

local play = Gamestate.new()

function play:enter()
   self:reset()   
   r, g, b, a = love.graphics.getColor()
   Sound.playGameMusic()
end

function play:reset()
   startTime = love.timer.getTime()
   time = 0
   newSpawnTime = self:nextSpawnTime()
   counter = 0
   lives = 10

   player = Player()
   hud = Hud()

   saddies = {}
   deadSaddies = {}
   obstructions = {}

   -- These are hardcoded coordinates relating to the static background.
   table.insert(obstructions, Obstruction(Vector(0, 0), 255, 230))
   table.insert(obstructions, Obstruction(Vector(775, 0), 245, 230))
   table.insert(obstructions, Obstruction(Vector(370, 0), 315, 230))
   table.insert(obstructions, Obstruction(Vector(425, 395), 155, 80))

   for i = 1, 5 do
      table.insert(saddies, Saddie(self:randomPoint(Vector(Constants.SADDIE_WIDTH, Constants.SADDIE_HEIGHT))))
   end

   action = nil

   mouth = Mouth()
   wave = Wave()
   activeItem = mouth;

   toolbar = Toolbar()
end

function play:endGame()
   Gamestate.switch(gameOver)
end

function play:calcMousePlayerAngle()
   mousedelta = Vector(love.mouse.getX(), love.mouse.getY())
   mousedelta = mousedelta - player.position
   mousedelta.y = - mousedelta.y
   return math.atan2(mousedelta.y, mousedelta.x)
end


function play:update(dt)
   time = time + dt
   
   self:addSaddies()

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
         table.remove(deadSaddies, i)
      end
   end
   player:update(dt)
   
   if math.floor(lives) <= 0 then
      self:endGame()
   end

   local averageSaddieHealth = self:getAverageSaddieHealth()

   Sound.update(averageSaddieHealth)

   timeElapsed = math.floor(love.timer.getTime() - startTime)
end

function play:draw()
   love.graphics.draw(background)
   activeItem:drawEffectiveArea(player:getPosition());

   for i, saddie in ipairs(saddies) do
      saddie:draw(time)
   end
   for i, saddie in ipairs(deadSaddies) do
      saddie:draw(time)
   end
   for i, obs in pairs(obstructions) do
      obs:draw()
   end

   player:draw(time)
   hud:draw(time)
   
   if action ~= nil then
      action.draw(time)
   end
   
   toolbar:draw()

   love.graphics.print(math.floor(time), 50, 50)
   love.graphics.print(math.floor(lives), 50, 70)
end

-- x: Mouse x position.
-- y: Mouse y position.
-- button: http://www.love2d.org/wiki/MouseConstant
function play:mousepressed(x, y, button)
   if button == "r" then
      player.targetpos = Vector(x, y)
      action = nil
   elseif button == "l" then
      self:performAction()
   end
end

function play:performAction()
   affectedSaddies = activeItem:getAffectedSaddies(player:getPosition(), saddies)

   for i, saddie in ipairs(affectedSaddies) do
      saddie:giveHappiness(5, 5)
   end
end

function play:getAverageSaddieHealth()
   local totalHealth = 0

   for i, saddie in ipairs(saddies) do
      totalHealth = totalHealth + saddie.health
   end

   return totalHealth / #saddies
end

function play:keypressed(key, unicode)
   if(love.keyboard.isDown('c')) then
      table.insert(saddies, Saddie(self:randomPoint(Vector(Constants.PLAYER_WIDTH, Constants.PLAYER_HEIGHT))))
   end
   if key == 'q' then
      -- action = QAction()
   elseif key == 'w' then
      -- action = WAction()
   elseif key == 'e' then
      -- action = EAction()
   elseif key == ' ' then
      self:performAction()
   elseif key == 'r' then
      -- action = RAction()
      reset()
   end

   if key == '1' then
      activeItem = mouth
   elseif key == '2' then
      activeItem = wave
   end
end

-- Potentially add some number of new saddies, dependent on game conditions.
function play:addSaddies()
   if time > newSpawnTime then
      -- Simple difficulty scaling dependent on time elapsed.
      for i = 1, math.floor(time / 5) do
         table.insert(saddies, Saddie(self:randomPoint(Vector(Constants.SADDIE_WIDTH, Constants.SADDIE_HEIGHT))))
      end
      newSpawnTime = self:nextSpawnTime()
      lives = lives + 0.25
   end
end

-- Determine the next time we want to spawn saddies.
function play:nextSpawnTime()
   return time + 5
end

function play:randomPoint(dim)
   local randomX,randomY = 0,0
	repeat	  
      randomX = math.random(0,Constants.SCREEN_WIDTH - dim.x)
      randomY = math.random(0,Constants.SCREEN_HEIGHT - dim.y)

      obstructed = false
      for i, obs in ipairs(obstructions) do
         if math.abs(randomX-obs.position.x) < (dim.x+obs.width)/2 and
         math.abs(randomY-obs.position.y) < (dim.y+obs.height)/2 then
            obstructed = true
         end
      end

   until(not obstructed and self:checkSpawn(randomX,randomY))
   randomVector = Vector.new(randomX,randomY)
   return randomVector
end

function play:checkSpawn(x,y)
   return (((x-player.position.x)^2+(y-player.position.y)^2)^.5 > Constants.SPAWN_RADIUS) 
   --checks is spawn point farther than [RADIUS]px 
   --may have to expand to prevent spawning on obstacles
end

return play
