local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local finalDelta = love.timer.getDelta()
local originalFont = love.graphics.newFont(18)
local scoreFont = love.graphics.newFont("assets/fonts/arialbd.ttf", 18)
local endFont = love.graphics.newFont("assets/fonts/pixel.ttf", 30)
local r,g,b,a = love.graphics.getColor()
score = 0
sadCount = 5
scoreList = {}
local Hud = Class(function(self)
    
end)

function Hud: load()
	initTime = love.timer.getTime()
	score = 0
	sadCount = 5
end

function Hud:draw(time)  
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill", 45,670,100,50)
   love.graphics.rectangle("fill", 860,20,190,30)
   
   love.graphics.setColor(255,255,230)
   
   love.graphics.setFont(scoreFont)
   score = score + (3*sadCount)
   love.graphics.setFont(originalFont)
   love.graphics.print("SCORE: " .. score, 870,20) 
   --love.timer.step()
   
   
   
   love.graphics.print("TIME: " .. math.floor(time), 50, 670)
   love.graphics.print("Lives: " .. math.floor(lives), 50, 700)
   
   love.graphics.setColor(r,g,b,a)
   
   
end

function Hud:getScore()
   return score
end

function Hud:getTime()
	return love.timer.getTime()
end

function Hud:sadIncrement(i)
   sadCount = sadCount + i
end
function Hud: startDelta()
   love.timer.step()
end

function Hud:endDisplay(finalTime)
	currentScore = score
	table.insert(scoreList, score)
	table.sort(scoreList)
	if(scoreList[#scoreList] == currentScore) then 
		love.graphics.print("High Score!",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 2 + 30)
		end
   love.graphics.setColor(0,150,0)
   love.graphics.setFont(endFont)
   love.graphics.print("Game Over",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 2)
   
   
   love.graphics.setFont(scoreFont)
   love.graphics.print("FINAL SCORE: " .. self:getScore(),770,20)
   love.graphics.setFont(originalFont)
   love.graphics.print("Yout kept up to " .. sadCount .. " people happy for " .. math.floor(initTime) .. 
   " seconds", 40, 20)
   love.graphics.print("Press any key restart ",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 1.5)
	love.graphics.print("Quiting? press r",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 1.5 + 20)
   love.graphics.setColor(r,g,b,a)
         
end 

return Hud
