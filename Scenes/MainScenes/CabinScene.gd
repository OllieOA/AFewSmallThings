extends Node2D
class_name CabinScene

const OUTSIDE_SPRITE_FINAL_MOD = "14141a"
const OUTSIDE_SNOW_FINAL_MOD = "393945"

export (NodePath) onready var base_fire_randomiser = get_node(base_fire_randomiser) as AnimationPlayer
export (NodePath) onready var activity_fire_randomiser = get_node(activity_fire_randomiser) as AnimationPlayer

var my_scene_name: String

func _ready() -> void:
	my_scene_name = self.get_name()
	GameControl.current_scene_name = my_scene_name
	base_fire_randomiser.play("Randomiser")
	activity_fire_randomiser.play("Randomiser")
