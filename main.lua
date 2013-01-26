local Constants = require "constants"
local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"

local counter = 0
local player = {}
local saddies = {}
spriteDim = Vector.new(Constants.SADDIE_WIDTH, Constants.SADDIE_HEIGHT, 0, 0) --put the dimensions of sprites here 

function love.load()
   reset()   
   counter = 0
   r, g, b, a = love.graphics.getColor()
   
end

function reset()
   startTime = love.timer.getTime()
   timeElapsed = 0

   player = Player()

   saddies = {}

   for i = 1, 5 do
      table.insert(saddies, Saddie(randomPoint(spriteDim)))
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
   if(love.keyboard.isDown('c')) then
      table.insert(saddies, Saddie(randomPoint(spriteDim)))
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
   elseif button == "l" then
      performAction(Vector(x, y))
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

   for i, saddie in ipairs(affectedSaddies) do
      saddie:changeDirection()
   end
end

function randomPoint(spriteSize)
   local randomX,randomY = 0,0
	local boundaries = Vector.new(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)	  
   randomX = math.random(0,1024)
   randomY = math.random(0,720)
   while(randomX > (boundaries.x-spriteSize.x) or 
   randomY > (boundaries.y-spriteSize.y) or 
   checkSpawn(randomX,randomY)) do 
      randomX = math.random(0,1024)
      randomY = math.random(0,720)
   end
   randomVector = Vector.new(randomX,randomY)

   return randomVector
end

function checkSpawn(x,y)
   return (((x-player.position.x)^2+(y-player.position.y)^2)^.5 < Constants.SPAWN_RADIUS) 
   --checks is spawn point farther than [RADIUS]px 
end