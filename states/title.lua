local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Hud = require "entities.hud"

local title = Gamestate.new()

function title:enter()
   hud = Hud()
   hud:wipeScores()
end

function title:update(dt)

end

function title:draw()
   love.graphics.setFont(love.graphics.newFont(12))

   love.graphics.print("SADDIES",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 2)

   love.graphics.print("Press a letter for difficulty:",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5)

   love.graphics.print("e: Easy",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5+12)

   love.graphics.print("m: Medium",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5+24)

   love.graphics.print("h: Hard",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5+36)

   love.graphics.print("i: INSANE",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5+48)
   
   love.graphics.print("q: QUIT",
    Constants.SCREEN_WIDTH / 2,
    Constants.SCREEN_HEIGHT / 1.5+60)
end

function title:keypressed(key, unicode)
   if     key == "e" or key == "E" then
   elseif key == "m" or key == "M" then
      Constants.SADDIE_HEALTH_REDUCTION = -5
      Constants.SADDIE_SPEED = 20
   elseif key == 'h' or key == 'H' then
      Constants.SADDIE_HEALTH_REDUCTION = -15
      Constants.SADDIE_SPEED = 30
   elseif key == "i" or key == "I" then
      Constants.SADDIE_HEALTH_REDUCTION = -20
      Constants.SADDIE_SPEED = 50
   elseif key == 'q' or key == 'Q' then
      love.event.push('quit')
   end

   Gamestate.switch(play)
end

return title
