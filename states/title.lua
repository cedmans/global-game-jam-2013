local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Hud = require "entities.hud"

local title = Gamestate.new()
local titleBackground = love.graphics.newImage("assets/images/TitleScreen.png")

function title:enter()
   hud = Hud()
   hud:wipeScores()
end

function title:update(dt)

end

function title:draw()
   love.graphics.draw(titleBackground)
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
