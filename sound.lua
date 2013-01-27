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

function sound.update(dt, time)
   local volume = math.abs(math.sin(time / 20))

   heart:setVolume(volume)
end

function sound.playGameMusic()
   -- love.audio.play(music)
   -- love.audio.play(heart)
end

return sound
