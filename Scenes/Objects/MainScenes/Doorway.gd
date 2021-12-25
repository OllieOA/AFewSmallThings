extends Node2D

# const OUTSIDE_SPRITE_FINAL_MOD = "14141a"
# const OUTSIDE_SNOW_FINAL_MOD = "393945"
onready var doorway_tooltip = $Tooltips/TooltipDoorway

onready var base_fire_randomiser = $DefaultElements/Firelight/BaseLight/BaseLightRandomiser
onready var activity_fire_randomiser = $DefaultElements/Firelight/ActivityLight/ActivityLightRandomiser

# UI
onready var movement_animator = $DefaultElements/MovementButtons/SlowBob
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	GameControl.doorway_visited = true
	
	GlobalEvents.play_fireplace()
	GameControl.current_scene_name = "Doorway"
	base_fire_randomiser.play("Randomiser")
	activity_fire_randomiser.play("Randomiser")
	movement_animator.play("SlowBob")
	

func _process(delta: float) -> void:
	if GameControl.game_started and doorway_tooltip.visible:
		doorway_tooltip.hide()

	if not GameControl.game_started:
		if (
				GameControl.doorway_visited and 
				GameControl.kitchen_visited and 
				GameControl.fireplace_visited and 
				GameControl.storage_visted
			):
			GameControl.game_started = true
