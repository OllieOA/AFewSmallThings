extends Node2D

onready var fireplace_tooltip = $Tooltips/TooltipFireplace

onready var base_fire_randomiser = $DefaultElements/Firelight/BaseLight/BaseLightRandomiser
onready var activity_fire_randomiser = $DefaultElements/Firelight/ActivityLight/ActivityLightRandomiser

# UI
onready var movement_animator = $DefaultElements/MovementButtons/SlowBob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameControl.fireplace_visited = true
	GameControl.current_scene_name = "Fireplace"
	base_fire_randomiser.play("Randomiser")
	activity_fire_randomiser.play("Randomiser")
	movement_animator.play("SlowBob")
	

func _process(delta: float) -> void:
	if GameControl.game_started and fireplace_tooltip.visible:
		fireplace_tooltip.hide()
