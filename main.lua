local Constants = require "constants"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"
local Mouth = require "entities.mouth"
local originalFont = love.graphics.newFont(14)
local scoreFont = love.graphics.newFont("assets/fonts/pixel.ttf", 18) 

local counter = 0
local player = {}
local saddies = {}
local action = nil
local time = 0
local startTime

local mouth = {}
local activeItem = {}

function love.load()
   reset()   
   counter = 0
   r, g, b, a = love.graphics.getColor()
   
end

function reset()
   startTime = love.timer.getTime()
   time = 0

   player = Player()

   saddies = {}

   for i = 1, 5 do
      table.insert(saddies, Saddie(randomPoint(spriteDim)))
   end

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

   for i, saddie in ipairs(saddies) do
      saddie:update(dt)
      -- There's probably a better way to do this. -JP
      if saddie.health < 0 then
         saddies[i] = nil
      end
   end
   player:update(dt)

   affectedSaddies = activeItem:getAffectedSaddies(player:getPosition(), saddies)

   timeElapsed = math.floor(love.timer.getTime() - startTime)
end

function love.draw()
   mouth:drawEffectiveArea(player:getPosition());

   for i, saddie in ipairs(saddies) do
      saddie:draw(time)
   end

   player:draw(time)
   player:draw()
   if action ~= nil then
      action.draw(time)
   end

   love.graphics.print(math.floor(time), 50, 50)
   love.graphics.setFont(scoreFont)
   love.graphics.print("SCORE: " .. math.ceil(time*1000), 870,20)
   love.graphics.setFont(originalFont)
end

-- x: Mouse x position.
-- y: Mouse y position.
-- button: http://www.love2d.org/wiki/MouseConstant
function love.mousepressed(x, y, button)
   if button == "r" then
      player.targetpos = Vector(x, y)
      action = nil
   elseif button == "l" then
      if action ~= nil then
         action.perform()
         action = nil
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

function getAllSaddiesInRadiusFromPoint(point, radius)
   local closeSaddies = {}

   for i, saddie in ipairs(saddies) do
      if point:dist(saddie.position) < radius then
         table.insert(closeSaddies, saddie)
      end
   end

   return closeSaddies
end

-- Generic perform action function. We probably want to expand this to do
-- different things depending on our current "item".
function performAction(point)
   local affectedSaddies = getAllSaddiesInRadiusFromPoint(point, 150)
   print(affectedSaddies)

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
