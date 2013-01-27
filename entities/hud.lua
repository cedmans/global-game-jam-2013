local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local originalFont = love.graphics.newFont(18)
local scoreFont = love.graphics.newFont("assets/fonts/arialbd.ttf", 18)
local endFont = love.graphics.newFont("assets/fonts/pixel.ttf", 30)
score = 0  
local Hud = Class(function(self)
    
end)

function Hud:draw(time)  
   love.graphics.setFont(scoreFont)
   score = score + (3*#(saddies))
   love.graphics.setFont(originalFont)
   love.graphics.print("SCORE: " .. score, 870,20)
   
   love.graphics.print("TIME: " .. math.floor(time), 50, 50)
   love.graphics.print("Lives: " .. math.floor(lives), 50, 70)
end

function Hud:getScore()
   return score
end


function Hud:endDisplay(time)
   love.graphics.setFont(endFont)
   love.graphics.print("Game Over",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 2)
   
   love.graphics.setFont(scoreFont)
   love.graphics.print("FINAL SCORE: " .. self:getScore(),770,20)
   love.graphics.setFont(originalFont)
   love.graphics.print("Yout kept the world happy for  " .. math.floor(time) .. " seconds", 50, 40)
         
end 

return Hud