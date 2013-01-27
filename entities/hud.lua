local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Util = require "util"

local originalFont = love.graphics.newFont(14)
local scoreFont = love.graphics.newFont("assets/fonts/arialbd.ttf", 18)

local Hud = Class(function(self)
   self.score = 0   
end)

function Hud:draw(time)  
   love.graphics.setFont(scoreFont)
   self.score = self.score + #saddies*3
   love.graphics.setFont(originalFont)
   love.graphics.print("SCORE: " .. self.score, 870,20)
end

return Hud