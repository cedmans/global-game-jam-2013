local Constants = require "constants"

local sound = {}

local mainMusic = {}
local mainBeat = {}
local offBeat = {}
local gameOver = {}
local highFive = {}
local heartdown = {}
local heartup = {}

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

   highFive = love.audio.newSource("assets/sounds/high_five.ogg", "static")
   highFive:setVolume(1)

   heartdown = love.audio.newSource("assets/sounds/heart-down.wav")
   heartup = love.audio.newSource("assets/sounds/heart-up.wav")
end

function sound.update(averageSaddieHealthPercentage, percentLivesRemaining)
   local minBasedOnHealth = (1 - averageSaddieHealthPercentage)/4
   local blended = (1 - percentLivesRemaining) * (1 - averageSaddieHealthPercentage)

   volume = math.max(minBasedOnHealth, blended)
   volume = math.max(math.min(volume, 1), 0)

   offBeat:setVolume(volume)
end

function sound.playGameMusic()
   gameOver:stop()

   mainMusic:setVolume(2)
   mainMusic:rewind()
   mainMusic:play()

   mainBeat:setVolume(2)
   mainBeat:rewind()
   mainBeat:play()

   offBeat:setVolume(2)
   offBeat:rewind()
   offBeat:play()
end

function sound.setMainMusicVolume(volume)

end

function sound.gameOver()
   gameOver:setVolume(0)
   gameOver:play()
end

function sound.gameOverUpdate(timeElapsed)
   local fadeOutVolume = math.max(1 - (timeElapsed / Constants.FADE_OUT_TIME), 0) * 2
   local fadeInVolume = math.min(timeElapsed / Constants.FADE_IN_TIME, 1) * 2

   mainMusic:setVolume(fadeOutVolume)
   mainBeat:setVolume(fadeOutVolume)
   offBeat:setVolume(fadeOutVolume)
   gameOver:setVolume(fadeInVolume)
end

function sound.highFive()
   highFive:play()
end

function sound.heartDown()
   heartdown:play()
end

function sound.heartUp()
   heartup:play()
end

return sound
