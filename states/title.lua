local Gamestate = require "hump.gamestate"
local Constants = require "constants"

local title = Gamestate.new()

function title:enter()

end

function title:update(dt)

end

function title:draw()
   love.graphics.print("SADDIES",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 2)

   love.graphics.print("Press any key to play",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5)
end

function title:keypressed(key, unicode)
   Gamestate.switch(play)
end

return title
