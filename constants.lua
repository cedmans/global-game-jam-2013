local Constants = {}

Constants.DEBUG = true

Constants.SCREEN_WIDTH = 1024
Constants.SCREEN_HEIGHT = 720
Constants.SPAWN_RADIUS = 210 -- minimum spawn distance of NPC's.
Constants.TOOLBAR_ITEM_WIDTH = 100
Constants.TOOLBAR_ITEM_HEIGHT = 100

Constants.MIN_X = 0
Constants.MAX_X = Constants.SCREEN_WIDTH - Constants.TOOLBAR_ITEM_WIDTH;
Constants.MIN_Y = 0
Constants.MAX_Y = Constants.SCREEN_HEIGHT


Constants.PLAYER_WIDTH = 35
Constants.PLAYER_HEIGHT = 85
Constants.PLAYER_SPEED = 100

Constants.SADDIE_WIDTH = 100
Constants.SADDIE_HEIGHT = 102
Constants.SADDIE_SPEED = 15
Constants.SADDIE_ROUTE_LEG = 100

Constants.SADDIE_HEALTH_REDUCTION = -5 -- Units per second

Constants.SADNESS_BAR_OFFSET = 20
Constants.HEART_OFFSET = 50
Constants.HEART_REACH = 50
Constants.HEART_LOOP_LENGTH = 1

Constants.PERFECT_SADNESS = 100
Constants.WARNING_SADNESS = 30
Constants.CRITICAL_SADNESS = 10
Constants.SADNESS_ALERT_OFFSET = 18
Constants.STARTING_LIVES = 10

-- Item Constants
Constants.EFFECTIVE_AREA_COLOR = {r=0, g=102, b=0, a=100}

Constants.MOUTH_EFFECTIVE_RADIUS = 100
Constants.MOUTH_HEALTH_EFFECT = 30
Constants.MOUTH_HEALTH_DURATION = 5

Constants.WAVE_EFFECTIVE_DISTANCE = 350
Constants.WAVE_ANGLE_OF_OCCURRENCE = 3
Constants.WAVE_HEALTH_EFFECT = 1.5
Constants.WAVE_HEALTH_DURATION = 0.5

-- Number of seconds to wait until the user can skip the game over screen.
Constants.GAME_OVER_SKIP_DELAY = 1.0

return Constants
