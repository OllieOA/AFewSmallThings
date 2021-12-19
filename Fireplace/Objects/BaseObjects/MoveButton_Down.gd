extends MoveButton

func _ready() -> void:
	outline_alert_level1_texture = load("res://Assets/UI/UIMovement_Down_Alert1.png")
	outline_alert_level2_texture = load("res://Assets/UI/UIMovement_Down_Alert2.png")
	self.connect("object_selected", self, "_move_select", ["Down"])


func _move_select(direction):
	var curr_dir_options = direction_dict[GameControl.current_scene_name]
	var scene_in_direction_of = curr_dir_options[direction]
	var scene_name_in_direction_of = scene_lookup[scene_in_direction_of]
	GameControl.goto_scene(scene_name_in_direction_of, 4.0)
