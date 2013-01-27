local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local finalDelta = love.timer.getDelta()
local originalFont = love.graphics.newFont(18)
local endFont = love.graphics.newFont("assets/fonts/ARIALNI.ttf", 30)
local scoreFont = love.graphics.newFont("assets/fonts/STENCIL.ttf", 18)
local r,g,b,a = love.graphics.getColor()
score = 0
sadCount = 5
scoreList = {0,0,0}
local Hud = Class(function(self)
    
end)

function Hud: load()
	initTime = love.timer.getTime()
	score = 0
	sadCount = 5
end

function Hud: wipeScores()
   scoreList = {0,0,0}
end



function Hud:draw(time)  
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill", 45,650,100,50)
   love.graphics.rectangle("fill", 860,20,190,30)
   
   love.graphics.setColor(255,255,230)
   
   love.graphics.setFont(scoreFont)
   score = score + (3*sadCount)
   love.graphics.setFont(originalFont)
   love.graphics.print("SCORE: " .. score, 870,20) 
   --love.timer.step()
   
   
   
   love.graphics.print("TIME: " .. math.floor(time), 50, 650)
   love.graphics.print("Lives: " .. math.floor(lives), 50, 680)
   
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


function Hud: setScore()
   currentScore = score
	table.insert(scoreList, score)
	table.sort(scoreList)
end

function Hud:endDisplay(finalTime)
	if(scoreList[#scoreList] == currentScore) then 
		love.graphics.print("High Score!",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 2 + 30)
		end
   love.graphics.setColor(0,150,0)
   love.graphics.setFont(endFont)
   love.graphics.print("Game Over",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 2)
   love.graphics.print("Yout kept up to " .. sadCount .. " people happy for " .. math.floor(initTime) .. 
   " seconds", 40, 20)
   
   
   love.graphics.setFont(scoreFont)
   love.graphics.print("FINAL SCORE: " .. currentScore,770,20)
   love.graphics.print("-------------------------" ,770,40)
   love.graphics.print("CURRENT HIGHEST SCORES" ,720,60)
   love.graphics.print("-------------------------" ,770,80)
   love.graphics.print("#1: " .. scoreList[#scoreList],770,100)
   love.graphics.print("#2: " .. scoreList[(#scoreList-1)],770,120)
   love.graphics.print("#3: " .. scoreList[(#scoreList-2)],770,140)
   
   love.graphics.setFont(originalFont)
   love.graphics.print("You kept up to " .. sadCount .. " people happy for " .. math.floor(timeElapsed) .. 
   " seconds", 40, 20)

	love.graphics.print("Go to title? (t)",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 1.5 + 0)
   love.graphics.print("Quitting? (q)",Constants.SCREEN_WIDTH / 2, Constants.SCREEN_HEIGHT / 1.5 + 20)
   love.graphics.print("Restart? (any other)",Constants.SCREEN_WIDTH / 2,Constants.SCREEN_HEIGHT / 1.5 + 40)
   love.graphics.setColor(r,g,b,a)
         
end 

return Hud
