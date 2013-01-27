local Class = require "hump.class"
local Constants = require "constants"

local TextArea = Class(function(self, text, author)
   self.text = text
   self.author = author
   self.duration = Constants.TEXTAREA_DURATION
   self.color = {255, 255, 255, 255}
   self.bgColor = {0, 27, 106, 200}
end)

function TextArea:update(dt)
   self.duration = self.duration - dt
end

function TextArea:draw(time)
   local r, g, b, a = love.graphics.getColor()
   
   self.color[4] = math.min(self.duration * 255, 255)
   love.graphics.setColor(self.bgColor)
   love.graphics.rectangle(
      'fill',
      Constants.TEXTAREA_X_LOC,
      Constants.TEXTAREA_Y_LOC,
      Constants.TEXTAREA_X_SIZE,
      Constants.TEXTAREA_Y_SIZE)
   love.graphics.setColor(self.color)
   love.graphics.printf(
      self.text,
      Constants.TEXTAREA_X_OFFSET,
      Constants.TEXTAREA_Y_OFFSET,
      Constants.TEXTAREA_WRAP,
      'center')
   love.graphics.printf(
      '- '..self.author,
      Constants.TEXTAREA_X_OFFSET,
      Constants.TEXTAREA_Y_OFFSET+200,
      Constants.TEXTAREA_WRAP,
      'right')
   
   love.graphics.setColor(r, g, b, a)
end

function TextArea:finished()
   return self.duration <= 0
end

return TextArea
