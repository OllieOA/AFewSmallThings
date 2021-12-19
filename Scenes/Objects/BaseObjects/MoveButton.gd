extends SelectableItem

class_name MoveButton

var local_area_values
var my_direction

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
		"Up": "Balcony",  # NG+
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
	local_area_values = {
		"Doorway": -1,
		"Fireplace": -1,
		"Kitchen": -1,
		"Storage": -1
	}


func _process(delta: float) -> void:
	var left_scene = direction_dict[GameControl.current_scene_name]["Left"]
	var right_scene = direction_dict[GameControl.current_scene_name]["Right"]
	var down_scene = direction_dict[GameControl.current_scene_name]["Down"]
	
	var left_scene_curr_alert = EventManager.room_alert_levels[left_scene]
	var right_scene_curr_alert = EventManager.room_alert_levels[right_scene]
	var down_scene_curr_alert = EventManager.room_alert_levels[down_scene]
	
	if my_direction == "Left":
		_set_alert_level(left_scene_curr_alert, left_scene)
	if my_direction == "Right":
		_set_alert_level(right_scene_curr_alert, right_scene)
	if my_direction == "Down":
		_set_alert_level(down_scene_curr_alert, down_scene)
		

func _set_alert_level(level, area):
	if level == 1 and local_area_values[area] != 1:
		outline_alert_sprite.texture = outline_alert_level1_texture
		outline_alert_sprite.show()
		alert_animator.play("BlinkState1")
		local_area_values[area] = 1
		
	if level == 2 and local_area_values[area] != 2:
		outline_alert_sprite.texture = outline_alert_level2_texture
		outline_alert_sprite.show()
		alert_animator.play("BlinkState2")
		local_area_values[area] = 2
		
	if level == 3 and local_area_values[area] != 3:
		outline_alert_sprite.hide()
		alert_animator.stop()
		local_area_values[area] = 3

