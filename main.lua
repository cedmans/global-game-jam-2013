local Gamestate = require "hump.gamestate"
local Sound = require "sound"

-- Load game states.
play = require "states.play"
gameOver = require "states.gameover"

function love.load()
   Sound.load()
   -- Register the game state dispatcher and switch into the initial state.
   Gamestate.registerEvents()
   Gamestate.switch(play)
end
