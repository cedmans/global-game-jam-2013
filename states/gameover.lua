local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Hud = require "entities.hud"
local Sound = require "sound"

local gameOver = Gamestate.new()
local hud = Hud()

function gameOver:enter()
   Sound.gameOver()
end

function gameOver:update(dt)

end

function gameOver:draw()
   hud:endDisplay()
end

function gameOver:keypressed(key, unicode)
   Gamestate.switch(play)
end

return gameOver
