local Constants = {}

Constants.DEBUG = true

Constants.SCREEN_WIDTH = 1024
Constants.SCREEN_HEIGHT = 720
Constants.SPAWN_RADIUS = 210 -- minimum spawn distance of NPC's.
Constants.MIN_X = 0
Constants.MAX_X = Constants.SCREEN_WIDTH
Constants.MIN_Y = 0
Constants.MAX_Y = Constants.SCREEN_HEIGHT

Constants.PLAYER_WIDTH = 35
Constants.PLAYER_HEIGHT = 85
Constants.PLAYER_SPEED = 100

Constants.SADDIE_WIDTH = 100
Constants.SADDIE_HEIGHT = 102
Constants.SADDIE_SPEED = 15
Constants.SADDIE_ROUTE_LEG = 100

Constants.OBS_WIDTH = 100
Constants.OBS_HEIGHT = 100

Constants.SADDIE_HEALTH_REDUCTION = -5 -- Units per second

Constants.SADNESS_BAR_OFFSET = 20
Constants.PERFECT_SADNESS = 100
Constants.WARNING_SADNESS = 30
Constants.CRITICAL_SADNESS = 10
Constants.SADNESS_ALERT_OFFSET = 18

-- Item Constants
Constants.EFFECTIVE_AREA_COLOR = {r=0, g=102, b=0, a=100}
Constants.MOUTH_EFFECTIVE_RADIUS = 100
Constants.MOUTH_HEALTH_EFFECT = 7
Constants.MOUTH_HEALTH_DURATION = 5

return Constants
