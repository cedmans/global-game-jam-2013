local sound = {}

local music = {}

function sound.load()
   music = love.audio.newSource("assets/sounds/main_music.ogg", "static")
   music:setLooping(true)
end

function sound.playMain()
   love.audio.play(music)
end

return sound
