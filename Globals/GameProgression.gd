extends Node

signal random_change

var game_speed
var alert_cooldown_time
var global_win_state
var main_timer

# Game construction
var plus_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_speed = 1.0
	alert_cooldown_time = 1.0
	
	# Game construction
	plus_mode = false
	global_win_state = false
	
	
	
