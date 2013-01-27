local Gamestate = require "hump.gamestate"

-- Load game states.
play = require "states.play"

function love.load()
   -- Register the game state dispatcher and switch into the initial state.
   Gamestate.registerEvents()
   Gamestate.switch(play)
end
