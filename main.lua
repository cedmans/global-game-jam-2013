local Player = require "entities.player"

local counter = 0
local posX = 0
local posY = 0
local player = {}

function love.load()
   counter = 0
   posX = 400
   posY = 400

   player = Player()
end

function love.update(dt)
   player:update(dt)
end

function love.draw()
   player:draw(dt)
end
