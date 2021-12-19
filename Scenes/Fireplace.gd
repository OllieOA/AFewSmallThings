extends Node2D

onready var base_fire_randomiser = $DefaultElements/Firelight/BaseLight/BaseLightRandomiser
onready var activity_fire_randomiser = $DefaultElements/Firelight/ActivityLight/ActivityLightRandomiser

# UI
onready var movement_animator = $DefaultElements/MovementButtons/SlowBob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameControl.current_scene_name = "Fireplace"
	base_fire_randomiser.play("Randomiser")
	activity_fire_randomiser.play("Randomiser")
	movement_animator.play("SlowBob")
	
