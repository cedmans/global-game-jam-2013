local counter = 0

function love.init()
   counter = 0
end

function love.update()
   counter = (counter + 1) % 100
end

function love.draw()
   love.graphics.print(counter, 400, 300)
end
