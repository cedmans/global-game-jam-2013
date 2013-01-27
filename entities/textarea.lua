local Class = require "hump.class"
local Constants = require "constants"

local TextArea = Class(function(self, text, author)
   self.text = text
   self.author = author
   self.color = {255, 255, 255, 255}
   self.bgColor = {0, 27, 106, 200}
end)

function TextArea:draw(time)
   local r, g, b, a = love.graphics.getColor()
   
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

return TextArea
