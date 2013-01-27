local Gamestate = require "hump.gamestate"
local Sound = require "sound"

-- Load game states.
title = require "states.title"
play = require "states.play"
gameOver = require "states.gameover"

function love.load()
   Sound.load()
   -- Register the game state dispatcher and switch into the initial state.
   Gamestate.registerEvents()
   Gamestate.switch(title)
<<<<<<< HEAD
end
=======
end
>>>>>>> a7d1f6b05a16ca73fdccc4a2eac621f35fa58712
