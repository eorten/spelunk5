class_name GameState extends RefCounted

enum States { PLAYING, BETWEEN_RUN, BETWEEN_ROUND }

var state: States
var biome_selected: bool

func _init(initial_state:States, biome_selected:bool) -> void:
	state = initial_state
	self.biome_selected = biome_selected
	
#Gameplay loop:
#1.Craft gear and equip your robots - batterybackpack, lasertool, intense light and more. - GAMESTATE: BETWEEN_ROUND
#
#2. Select biome to travel to - like fungal or lava caverns  - biome_selected: TRUE
#
#3. Buy equipment and venture down - explore, build a mine, destroy enemies and gather resources to fill a quota. - GAMESTATE: BETWEEN_RUN and PLAYING
#
#4. After 5 runs, the player may continue to new biome if the quota was filled, or loses if quota was not filled. biome_selected = FALSE
#Excess resources are kept for buying or crafting equipment for the robots - back to step 1. - GAMESTATE: BETWEEN_ROUND
