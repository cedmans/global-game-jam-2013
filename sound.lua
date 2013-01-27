local sound = {}

local mainMusic = {}
local mainBeat = {}
local offBeat = {}
local gameOver = {}

function sound.load()
   mainMusic = love.audio.newSource("assets/sounds/main_music.ogg", "static")
   mainMusic:setLooping(true)
   mainMusic:setVolume(2)

   mainBeat = love.audio.newSource("assets/sounds/main_beat.ogg", "static")
   mainBeat:setLooping(true)
   mainBeat:setVolume(2)

   offBeat = love.audio.newSource("assets/sounds/off_beat.ogg", "static")
   offBeat:setLooping(true)
   offBeat:setVolume(2)

   gameOver = love.audio.newSource("assets/sounds/game_over.ogg", "static")
   gameOver:setVolume(2)
end

function sound.update(averageSaddieHealthPercentage, percentLivesRemaining)
   local minBasedOnHealth = (1 - averageSaddieHealthPercentage)/4
   local blended = (1 - percentLivesRemaining) * (1 - averageSaddieHealthPercentage)

   volume = math.max(minBasedOnHealth, blended)
   volume = math.max(math.min(volume, 1), 0)

   offBeat:setVolume(volume)
end

function sound.playGameMusic()
   mainMusic:rewind()
   mainMusic:play()

   mainBeat:rewind()
   mainBeat:play()

   offBeat:rewind()
   offBeat:play()
end

function sound.setMainMusicVolume(volume)

end

function sound.gameOver()
   mainMusic:stop()
   mainBeat:stop()
   offBeat:stop()
   gameOver:play()
end

return sound
