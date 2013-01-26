local Class = require "hump.class"
local Util = Class()

-- Calculate at what percentage `middle` is located in the range from `bottom`
-- to `top`.
-- @author JP
function Util:percentageOfRange(top, middle, bottom)
   return (middle - bottom) / (top - bottom)
end

return Util

