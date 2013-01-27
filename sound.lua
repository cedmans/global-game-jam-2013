local sound = {}

local music = {}
local heart = {}

function sound.load()
   music = love.audio.newSource("assets/sounds/main_music.ogg", "static")
   music:setLooping(true)
   music:setVolume(0.5)

   heart = love.audio.newSource("assets/sounds/heart.ogg", "static")
   heart:setLooping(true)
end

function sound.update(averageSaddieHealthPercentage, percentLivesRemaining)
   local minBasedOnHealth = (1 - averageSaddieHealthPercentage)/4
   local blended = (1 - percentLivesRemaining) * (1 - averageSaddieHealthPercentage)

   volume = math.max(minBasedOnHealth, blended)
   volume = math.max(math.min(volume, 1), 0)

   heart:setVolume(volume)
end

function sound.playGameMusic()
   -- love.audio.play(music)
   -- love.audio.play(heart)
end

function sound.gameOver()
   heart:setVolume(0.5)
end

return sound
