extends Node2D

var following_scene
var current_scene
var current_scene_name

var game_started
var kitchen_visited
var doorway_visited
var fireplace_visited
var storage_visted

onready var animation_player = $AnimationPlayer
onready var music_audio = $Music
onready var music_fade = $Music/AudioFade
onready var cursor_sprite = $CanvasLayer/Cursor
var main_input_name
var cancel_input_name

# Set up a cursor inventory
var cursor_inventory

func _ready() -> void:
	game_started = true # TEST
	kitchen_visited = false
	doorway_visited = false
	fireplace_visited = false
	
	main_input_name = "MainAction"
	cancel_input_name = "CancelAction"
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	animation_player.play_backwards("Fade")
	
	cursor_inventory = null

# Scene management
func _process(delta: float) -> void:
	if cursor_inventory != null:
		cursor_sprite.position = get_global_mouse_position()


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
	if GameControl.following_scene != null:
		call_deferred("process_scene_transition", GameControl.following_scene)
	GameControl.following_scene = null


func update_cursor_texture(texture_path):
	cursor_sprite.texture = texture_path
	if cursor_sprite.texture == null:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

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
