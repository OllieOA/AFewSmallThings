extends Node2D


var followingScene
var currentScene

onready var animator_player = $AnimationPlayer

func _ready() -> void:
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	print(currentScene.get_name())
	animator_player.play("Fade")


func goto_scene(path):
	followingScene = path
	animator_player.playback_speed = 2
	animator_player.play_backwards()
	
	
func process_scene_transition(path):
	currentScene.queue_free()
	
	var new_scene = ResourceLoader.load(path)
	currentScene = new_scene.instance()
	
	get_tree().get_root().add_child(currentScene)
	get_tree().set_current_scene(currentScene)
	
	animator_player.play()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("level1"):
		goto_scene("res://Levels/Level1.tscn")
	if event.is_action_pressed("level2"):
		goto_scene("res://Levels/Level2.tscn")
	if event.is_action_pressed("level3"):
		goto_scene("res://Levels/Level3.tscn")
	if event.is_action_pressed("level4"):
		goto_scene("res://Levels/Level4.tscn")
	


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	# Only transition once animation has completed
	if scene_transition.followingScene != null:
		call_deferred("process_scene_transition", scene_transition.followingScene)
	scene_transition.followingScene = null
