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
   end

   if (love.keyboard.isDown('s')) then
      posY = posY + 200 * dt
   end

   if (love.keyboard.isDown('a')) then
      posX = posX - 200 * dt
   end

   if (love.keyboard.isDown('d')) then
      posX = posX + 200 * dt
   end
end

function love.draw()
   love.graphics.print(counter, posX, posY)
end
