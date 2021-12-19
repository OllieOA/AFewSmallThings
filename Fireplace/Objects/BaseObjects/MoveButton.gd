extends SelectableItem

class_name MoveButton

var direction_dict = {
	"Doorway": {
		"Left": "Fireplace",
		"Right": "Storage",
		"Down": "Kitchen",
	},
	"Fireplace": {
		"Left": "Kitchen",
		"Right": "Doorway",
		"Down": "Storage",
	},
	"Kitchen": {
		"Left": "Storage",
		"Right": "Fireplace",
		"Down": "Doorway",
		"Up": "Balcony",
	},
	"Storage": {
		"Left": "Doorway",
		"Right": "Kitchen",
		"Down": "Fireplace",
	},
}

var scene_lookup = {
	"Doorway": "res://Scenes/Doorway.tscn",
	"Fireplace": "res://Scenes/Fireplace.tscn",
	"Kitchen": "res://Scenes/Kitchen.tscn",
	"Storage": "res://Scenes/Storage.tscn",
}

func _ready() -> void:
	selectable = true
#	self.connect("object_selected", self, "_move_select", [button_name])
#
#
#func _move_select(direction):
#	print("DEBUG: CURR SCENE NAME ", GameControl.current_scene_name)
#	var curr_dir_options = direction_dict[GameControl.current_scene_name]
#	print("DEBUG: CURR_OPTIONS ", curr_dir_options)
#	print("DEBUG: DIRECTION ", direction)
#	var scene_in_direction_of = curr_dir_options[direction]
#	var scene_name_in_direction_of = scene_lookup[scene_in_direction_of]
#	GameControl.goto_scene(scene_name_in_direction_of, 4.0)
	
	
