local Player = require "entities.player"

local counter = 0
local posX = 0
local posY = 0
local player = {}

function love.load()
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
