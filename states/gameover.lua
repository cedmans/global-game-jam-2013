local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Hud = require "entities.hud"
local Sound = require "sound"

local gameOver = Gamestate.new()
local hud = Hud()

local time = 0

function gameOver:enter()
   Sound.gameOver()
   time = 0
end

function gameOver:update(dt)
   time = time + dt
end

function gameOver:draw()
   hud:endDisplay()
end

function gameOver:keypressed(key, unicode)
   if time > Constants.GAME_OVER_SKIP_DELAY then
      Gamestate.switch(title)
   end
end

return gameOver
