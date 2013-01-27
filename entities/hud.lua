local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local originalFont = love.graphics.newFont(14)
local scoreFont = love.graphics.newFont("assets/fonts/arialbd.ttf", 18)
score = 0  
local Hud = Class(function(self)
    
end)

function Hud:draw(time)  
   love.graphics.setFont(scoreFont)
   score = score + 3
   love.graphics.setFont(originalFont)
   love.graphics.print("SCORE: " .. score, 870,20)
end

function Hud:getScore()
   return score
end

return Hud