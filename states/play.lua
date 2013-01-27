local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Sound = require "sound"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"
local DeadSaddie = require "entities.deadsaddie"
local Obstruction = require "entities.obstruction"
local Toolbar = require 'entities.toolbar'
local Mouth = require "actions.mouth"
local Wave = require "actions.wave"
local Hud = require "entities.hud"
local ExplodingText = require "entities.explodingtext"
local TextArea = require "entities.textarea"

local counter = 0
obstructions = {}
saddies = {}
local deadSaddies = {}
local time = 0
local startTime
local hud = {}
local explodingTexts
local dieTime = love.timer.getDelta()
player = {}
lives = {}

local counter, saddies, deadSaddies, time, startTime,
      newSpawnTime, toolbar, textArea

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
   lives = Constants.STARTING_LIVES

   player = Player()
   hud = Hud()
   hud: load()

   saddies = {}
   deadSaddies = {}
   obstructions = {}
   explodingTexts = {}
   textArea = TextArea("There sure are a lot of unhappy people here.",
                       player.name)

   -- These are hardcoded coordinates relating to the static background.
   table.insert(obstructions, Obstruction(Vector(0+255/2, 0+230/2), 255, 230))
   table.insert(obstructions, Obstruction(Vector(775+245/2, 0+230/2), 245, 230))
   table.insert(obstructions, Obstruction(Vector(370+315/2, 0+230/2), 315, 230))
   table.insert(obstructions, Obstruction(Vector(425+155/2, 395+80/2), 155, 80))

   -- World Boundaries
   table.insert(obstructions, Obstruction(Vector(0+Constants.SCREEN_WIDTH/2,0+Constants.TOOLBAR_ITEM_HEIGHT/2), Constants.SCREEN_WIDTH, Constants.TOOLBAR_ITEM_HEIGHT))
   table.insert(obstructions, Obstruction(Vector(0,0),0,Constants.SCREEN_HEIGHT))
   table.insert(obstructions, Obstruction(Vector(0,Constants.SCREEN_HEIGHT), Constants.SCREEN_WIDTH, 0))
   table.insert(obstructions, Obstruction(Vector(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT), 0, Constants.SCREEN_HEIGHT))

   for i = 1, 5 do
      table.insert(saddies, Saddie(self:randomPoint(Vector(Constants.SADDIE_WIDTH, Constants.SADDIE_HEIGHT))))
   end

   mouth = Mouth()
   wave = Wave()
   activeItem = mouth;

   toolbar = Toolbar()
end

function play:endGame()
	--hud:getTime()
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
         table.insert(explodingTexts, ExplodingText("DEATH"))
      end
   end
   for i, saddie in ipairs(deadSaddies) do
      saddie:update(dt)
      if saddie:finishedDying() then
         table.remove(deadSaddies, i)
      end
   end
   for i, text in ipairs(explodingTexts) do
      text:update(dt)
      if text:finished() then
         table.remove(explodingTexts, i)
      end
   end
   player:update(dt)
   if textArea then
      textArea:update(dt)
      if textArea:finished() then
         textArea = nil
      end
   end
   
   if math.floor(lives) <= 0 then
      
      self:endGame()
   end

   local averageSaddieHealth = self:getAverageSadnessFromSaddestSaddies()
   local percentLivesRemaining = self:getPercentLivesRemaining()

   Sound.update(averageSaddieHealth/100, percentLivesRemaining)

   timeElapsed = math.floor(love.timer.getTime() - startTime)
end

function play:draw()
   love.graphics.draw(background)
   activeItem:drawEffectiveArea(player:getPosition());
   if textArea then
      textArea:draw()
   end

   for i, saddie in ipairs(saddies) do
      saddie:draw(time)
   end
   for i, saddie in ipairs(deadSaddies) do
      saddie:draw(time)
   end
   for i, obs in pairs(obstructions) do
      obs:draw()
   end
   for i, texts in ipairs(explodingTexts) do
      texts:draw()
   end

   player:draw(time)
   hud:draw(time)
   
   toolbar:draw()
end

-- x: Mouse x position.
-- y: Mouse y position.
-- button: http://www.love2d.org/wiki/MouseConstant
function play:mousepressed(x, y, button)
   if button == "l" then
      player.targetpos = Vector(x, y)
      angle = player:getMouseAngle()
      if angle < -math.pi*3/4 then
         player:setDirection("left")
      elseif angle < -math.pi/4 then
         player:setDirection("down")
      elseif angle < math.pi/4 then
         player:setDirection("right")
      elseif angle < math.pi*3/4 then
         player:setDirection("up")
      else
         player:setDirection("left")
      end
   elseif button == "r" then
      self:performAction()
   end
end

function play:performAction()
   if not activeItem:enabled() then
      return
   end
   
   activeItem:activate()

   affectedSaddies = activeItem:getAffectedSaddies(player:getPosition(), saddies)

   for i, saddie in ipairs(affectedSaddies) do
      saddie:giveHappiness(5, 5)
   end
end

function play:getAverageSadnessFromSaddestSaddies()
   local totalHealth = 0
   local numSaddies = math.floor(math.max(#saddies/3, 1)) -- Only factor in saddest third

   table.sort(saddies, function(saddie1, saddie2)
      return saddie1.health < saddie2.health
   end)

   for i, saddie in ipairs(saddies) do
      if i > numSaddies then
         break
      end

      totalHealth = totalHealth + saddie.health
   end

   return totalHealth/numSaddies
end

function play:getPercentLivesRemaining()
   -- Lives remaining as a percentage of starting lives with a max of 1.
   return math.min(lives / Constants.STARTING_LIVES, 1)
end

function play:keypressed(key, unicode)
   if(love.keyboard.isDown('c')) then
      table.insert(saddies, Saddie(self:randomPoint(Vector(Constants.PLAYER_WIDTH, Constants.PLAYER_HEIGHT))))
   end
   if key == ' ' then
      self:performAction()
   elseif key == '1' then
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
         hud:sadIncrement(1)
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
