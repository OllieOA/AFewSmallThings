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


func _process(delta: float) -> void:
	pass
	# Read the current scene
	# Read the direction of each other scene
	# Read the alert state
	# Play outline alert animation on button
	
	for direction in direction_dict.keys():
		var curr_max_alert = EventManager.room_alert_levels[direction]
		

