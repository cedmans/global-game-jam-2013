local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"
local originalFont = love.graphics.newFont(14)
local scoreFont = love.graphics.newFont("assets/fonts/arialbd.ttf", 18)

local Score = Class(function(self)
   
end)

function Score:draw(time)
   love.graphics.print(math.floor(time), 50, 50)    
   love.graphics.setFont(scoreFont)
   score = score + #saddies
   love.graphics.setFont(originalFont)

   love.graphics.print("SCORE: " .. score, 870,20)
end