extends Node

signal random_change

var global_win_state
var main_timer
var random_out
var rng = RandomNumberGenerator.new()

# Game construction
var plus_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	
	main_timer = Timer.new()
	add_child(main_timer)
	main_timer.autostart = true
	main_timer.wait_time = 1.0
	main_timer.connect("timeout", self, "main_timeout")
	# main_timer.start()
	
	# Game construction
	plus_mode = false
	global_win_state = true
	

func main_timeout():
	print("Timeout")
	random_out = rng.randi_range(0, 100)
	emit_signal("random_change")
	
	
