extends SelectableItem
class_name MoveButton

var local_area_values
var my_direction
var scene_change_speed
export (NodePath) onready var bob_animator = get_node(bob_animator) as AnimationPlayer

var left_scene
var right_scene
var down_scene

var left_scene_curr_alert
var right_scene_curr_alert
var down_scene_curr_alert

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
	"Doorway": "res://Scenes/MainScenes/Doorway.tscn",
	"Fireplace": "res://Scenes/MainScenes/Fireplace.tscn",
	"Kitchen": "res://Scenes/MainScenes/Kitchen.tscn",
	"Storage": "res://Scenes/MainScenes/Storage.tscn",
}

func _ready() -> void:
	selectable = true
	local_area_values = {
		"Doorway": -1,
		"Fireplace": -1,
		"Kitchen": -1,
		"Storage": -1
	}
	scene_change_speed = 3.0
	bob_animator.play("SlowBob")


func _process(_delta: float) -> void:
	left_scene = direction_dict[GameControl.current_scene_name]["Left"]
	right_scene = direction_dict[GameControl.current_scene_name]["Right"]
	down_scene = direction_dict[GameControl.current_scene_name]["Down"]
	
	left_scene_curr_alert = EventManager.room_alert_levels[left_scene]
	right_scene_curr_alert = EventManager.room_alert_levels[right_scene]
	down_scene_curr_alert = EventManager.room_alert_levels[down_scene]
	
	if my_direction == "Left":
		_set_alert_level(left_scene_curr_alert, left_scene)
	if my_direction == "Right":
		_set_alert_level(right_scene_curr_alert, right_scene)
	if my_direction == "Down":
		_set_alert_level(down_scene_curr_alert, down_scene)
		

func _set_alert_level(level, area):
	if level == 1 and local_area_values[area] != 1:
		alert_animator.play("BlinkState1")
		local_area_values[area] = 1
		
	if level == 2 and local_area_values[area] != 2:
		alert_animator.play("BlinkState2")
		local_area_values[area] = 2
		
	if level == 3 and local_area_values[area] != 3:
		alert_sprite.hide()
		local_area_values[area] = 3


func _move_select(direction):
	var curr_dir_options = direction_dict[GameControl.current_scene_name]
	var scene_in_direction_of = curr_dir_options[direction]
	var scene_name_in_direction_of = scene_lookup[scene_in_direction_of]
	GameControl.goto_scene(scene_name_in_direction_of, scene_change_speed)
