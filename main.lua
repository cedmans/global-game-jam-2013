local Player = require "entities.player"

local counter = 0
local posX = 0
local posY = 0
local player = {}

function love.load()
   reset()
end

function reset()
   startTime = love.timer.getTime()
   timeElapsed = 0
   posX = 400
   posY = 400

   player = Player()
end

function love.update(dt)
   player:update(dt)
   timeElapsed = math.floor(love.timer.getTime() - startTime)
end

function love.draw()
   player:draw(dt)
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
