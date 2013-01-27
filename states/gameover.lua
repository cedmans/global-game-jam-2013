local Gamestate = require "hump.gamestate"
local Constants = require "constants"

local gameOver = Gamestate.new()

function gameOver:enter()

end

function gameOver:update(dt)

end

function gameOver:draw()
   love.graphics.print("Game Over",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 2)
end

return gameOver
