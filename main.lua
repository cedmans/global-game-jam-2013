local Vector = require "hump.vector"
local Player = require "entities.player"
local Saddie = require "entities.saddie"

local counter = 0
local posX = 0
local posY = 0
local player = {}
local saddies = {}

function love.load()
   reset()
end

function reset()
   startTime = love.timer.getTime()
   timeElapsed = 0
   posX = 400
   posY = 400

   player = Player()

   saddies = {}

   for i = 1, 5 do
      table.insert(saddies, Saddie(Vector(i * 125, i * 100)))
   end
end

function love.update(dt)
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

function love.mousepressed(x, y, button)
   -- For now, reset the game on right-click.
   if button == "r" then
      reset()
   end
end
