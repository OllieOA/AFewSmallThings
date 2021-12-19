extends Node2D

var following_scene
var current_scene
var current_scene_name

onready var animation_player = $AnimationPlayer

# Set up a cursor inventory
var cursor_inventory

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	animation_player.play_backwards("Fade")
	
	cursor_inventory = null

# Scene management

func goto_scene(path, speed=1):
	following_scene = path
	animation_player.playback_speed = speed
	animation_player.play("Fade")
	
	
func process_scene_transition(path):
	current_scene.queue_free()
	var new_scene = ResourceLoader.load(path)
	current_scene = new_scene.instance()
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	animation_player.play_backwards()
	

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	# Only transition once animation has completed
	print(GameControl.following_scene)
	if GameControl.following_scene != null:
		call_deferred("process_scene_transition", GameControl.following_scene)
	GameControl.following_scene = null


#func disable_input():
#	get_tree().get_root().set_process_input(false)
#	get_tree().get_root().set_process_unhandled_input(false)
#	get_tree().get_root().set_process_unhandled_key_input(false)
#
#func enable_input():
#	get_tree().get_root().set_process_input(true)
#	get_tree().get_root().set_process_unhandled_input(true)
#	get_tree().get_root().set_process_unhandled_key_input(true)
#
