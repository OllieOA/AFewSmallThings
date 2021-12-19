extends Node2D

# const OUTSIDE_SPRITE_FINAL_MOD = "14141a"
# const OUTSIDE_SNOW_FINAL_MOD = "393945"


onready var base_fire_randomiser = $DefaultElements/Firelight/BaseLight/BaseLightRandomiser
onready var activity_fire_randomiser = $DefaultElements/Firelight/ActivityLight/ActivityLightRandomiser

# UI
onready var movement_animator = $DefaultElements/MovementButtons/SlowBob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameControl.current_scene_name = "Doorway"
	base_fire_randomiser.play("Randomiser")
	activity_fire_randomiser.play("Randomiser")
	movement_animator.play("SlowBob")
	
