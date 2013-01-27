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
local LovePotion = require "actions.lovepotion"
local HighFive = require "actions.highfive"
local Hud = require "entities.hud"
local ExplodingText = require "entities.explodingtext"
local TextArea = require "entities.textarea"

local heartdown = love.audio.newSource("assets/sounds/heart-down.wav")

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
randomQuotes = {"Welcome! You're late.","Solutions that pile tons of horrible muck into these functions will not receive full credit.",
"There's still a problem...we actually *created* a new problem in solving our old problem.",
"It turns out to be very easy. And I'm going to make it a *little* bit harder than it needs to be.","Exciting is not always the same thing as nice.",
"And then some jerk comes along, and totally blows up the whole world!","This is probably a good time to ask: what COULD go wrong?",
"Okay! Let's do other crazy stuff."}

local counter, saddies, deadSaddies, time, startTime,
      newSpawnTime, toolbar, textArea, items, activeItem

timeElapsed = 0

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

   items = { Mouth(), Wave(), LovePotion(), HighFive() }
   activeItem = 1;

   toolbar = Toolbar()
end

function play:endGame()
	--hud:getTime()
   hud:setScore()
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
         heartdown:rewind()
         love.audio.play(heartdown)
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

   local chance = math.random(0, 100)
   if textArea then
      textArea:update(dt)
      if textArea:finished() then
         textArea = nil
      end
   elseif chance < 80 then
      textArea = TextArea(randomQuotes[math.random(1,#randomQuotes)], player.name)
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
   items[activeItem]:drawEffectiveArea(player:getPosition())
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
   
   toolbar:draw(items, activeItem)
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
   if not items[activeItem]:enabled() then
      return
   end

   affectedSaddies = items[activeItem]:getAffectedSaddies(player:getPosition(), saddies)

   local currentItem = items[activeItem]
   local duration = currentItem.duration
   local health = currentItem.health

   currentItem:activate(affectedSaddies)

   for i, saddie in ipairs(affectedSaddies) do
      saddie:giveHappiness(health, duration)
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
   if key == 'q' or key == 'Q' then
      love.event.push('quit')
   end

   if(love.keyboard.isDown('c')) then
      table.insert(saddies, Saddie(self:randomPoint(Vector(Constants.PLAYER_WIDTH, Constants.PLAYER_HEIGHT))))
   end
   if key == ' ' then
      self:performAction()
   elseif key == '1' then
      activeItem = 1
   elseif key == '2' then
      activeItem = 2
   elseif key == '3' then
      activeItem = 3
   elseif key == '4' then
      activeItem = 4
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
