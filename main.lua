local minX = 0
local maxX = 1024
local minY = 0
local maxY = 720

local counter = 0
local posX = 0
local posY = 0

function love.init()
   counter = 0
   posX = 400
   posY = 400
end

function love.update(dt)
   counter = (counter + 1) % 100

   if (love.keyboard.isDown('w')) then
      posY = posY - 200 * dt
      if posY < minY then
         posY = minY
      end
   end

   if (love.keyboard.isDown('s')) then
      posY = posY + 200 * dt
      if posY > maxY then
         posY = maxY
      end
   end

   if (love.keyboard.isDown('a')) then
      posX = posX - 200 * dt
      if posX < minX then
         posX = minX
      end
   end

   if (love.keyboard.isDown('d')) then
      posX = posX + 200 * dt
      if posX > maxX then
         posX = maxX
      end
   end
end

function love.draw()
   love.graphics.print(counter, posX, posY)
end
