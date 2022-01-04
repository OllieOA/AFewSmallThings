extends Node2D

# const OUTSIDE_SPRITE_FINAL_MOD = "14141a"
# const OUTSIDE_SNOW_FINAL_MOD = "393945"
onready var storage_tooltip = $Tooltips/TooltipStorage

onready var base_fire_randomiser = $DefaultElements/Firelight/BaseLight/BaseLightRandomiser
onready var activity_fire_randomiser = $DefaultElements/Firelight/ActivityLight/ActivityLightRandomiser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameControl.storage_visted = true
	GameControl.current_scene_name = "Storage"
	base_fire_randomiser.play("Randomiser")
	activity_fire_randomiser.play("Randomiser")
	
	
func _process(delta: float) -> void:
	if GameControl.game_started and storage_tooltip.visible:
		storage_tooltip.hide()
