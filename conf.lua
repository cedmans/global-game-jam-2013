-- https://love2d.org/wiki/Config_Files

local Constants = require "constants"

function love.conf(t)
   t.title = "Heart Healer Extreme"
   t.author = "WeDunIt"
   t.screen.width = Constants.SCREEN_WIDTH
   t.screen.height = Constants.SCREEN_HEIGHT
end
