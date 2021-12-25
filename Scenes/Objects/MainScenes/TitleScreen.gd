extends Node2D


onready var door_area = $DoorArea
onready var door_area_sprite = $DoorArea/MarkerSprite
onready var door_area_marker_animation = $DoorArea/MarkerSprite/DoorMarkerAnimator
var door_selected

# Collect buttons and tooltips
onready var start_container = $UIElements/StartGame/StartContainer
onready var start_button = $UIElements/StartGame/StartContainer/Start
onready var start_button_tooltip =$UIElements/StartGame/StartContainer/Start/StartLabelBase
onready var start_plus_button = $UIElements/StartGame/StartContainer/StartPlus
onready var start_plus_button_tooltip =$UIElements/StartGame/StartContainer/StartPlus/StartPlusLabelBase
onready var start_plus_unlock_button_tooltip =$UIElements/StartGame/StartContainer/StartPlus/StartPlusUnlockLabelBase
onready var start_hint = $UIElements/StartHint
onready var start_hint_animator = $UIElements/StartHint/StartHintAnimator
var start_hint_timer

# Get screen fade
onready var screen_fade = $UIElements/ScreenFade/ScreenFadeAnimator
onready var ambient_audio = $Ambient
onready var ambient_audio_fade = $Ambient/AudioFade
onready var ui_elements_fade = $UIElements/ButtonAndTitleFade

# Get camera
onready var camera_node = $CutsceneCamera
onready var camera_animator = $CutsceneCamera/CutsceneCameraAnimator

# Audio
onready var click_sound = $UIElements/ClickSound

func _ready() -> void:
	GameControl.current_scene_name = "TitleScreen"
	camera_node.position.x = 640.0
	camera_node.position.y = 360.0
	camera_node.zoom.x = 1.0
	camera_node.zoom.y = 1.0
	door_area_sprite.hide()
	door_selected = false
	
	# Hide everything needed
	start_button_tooltip.hide()
	start_plus_button_tooltip.hide()
	start_container.hide()
	start_plus_unlock_button_tooltip.hide()
	start_hint.hide()
	
	if GameProgression.global_win_state:
		start_plus_unlock_button_tooltip.hide()
	else:
		start_plus_button.disabled = true

	# Finally, fade in
	ambient_audio.volume_db = -80
	screen_fade.play("Fade")
	ambient_audio.play()
	ambient_audio_fade.play("FadeIn")
	
	# Fade in music after 1sec
	var music_timer = Timer.new()
	add_child(music_timer)
	music_timer.autostart = true
	music_timer.wait_time = 1.0
	music_timer.connect("timeout", self, "_music_fade_timeout")
	music_timer.one_shot = true
	music_timer.start()
	
	# Show start hint after 10sec
	start_hint_timer = Timer.new()
	add_child(start_hint_timer)
	start_hint_timer.autostart = true
	start_hint_timer.wait_time = 10.0
	start_hint_timer.connect("timeout", self, "_start_hint_timeout")
	start_hint_timer.one_shot = true
	start_hint_timer.start()


func _music_fade_timeout() -> void:
	GameControl.music_fade.play("FadeIn")
	GameControl.music_audio.play()

func _start_hint_timeout() -> void:
	start_hint.modulate.a = 0
	start_hint.show()
	start_hint_animator.play("Fade")
	

# Door logic

func _on_DoorArea_mouse_entered() -> void:
	if not door_selected:
		door_area_sprite.show()
		door_area_marker_animation.play("blink")


func _on_DoorArea_mouse_exited() -> void:
	if not door_selected:
		door_area_sprite.hide()
		door_area_marker_animation.stop(false)
	

func _on_DoorArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event.is_action_pressed(GameControl.main_input_name):
		click_sound.play()
		door_selected = true
		start_container.show()
		door_area_sprite.show()
		
		# Handle the hint
		if is_instance_valid(start_hint_timer):
			start_hint_timer.stop()
			start_hint_timer.queue_free()
			if start_hint.visible:
				start_hint_animator.play_backwards()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(GameControl.cancel_input_name):
		if door_selected:
			door_selected = false
			start_container.hide()
			door_area_sprite.hide()
			
			

# Tooltips
func _on_Start_mouse_entered() -> void:
	start_button_tooltip.show()


func _on_Start_mouse_exited() -> void:
	start_button_tooltip.hide()


func _on_StartPlus_mouse_entered() -> void:
	if GameProgression.global_win_state:
		start_plus_button_tooltip.show()
	else:
		start_plus_unlock_button_tooltip.show()


func _on_StartPlus_mouse_exited() -> void:
	if GameProgression.global_win_state:
		start_plus_button_tooltip.hide()
	else:
		start_plus_unlock_button_tooltip.hide()


# Handle Start Buttons

func _on_Start_button_up() -> void:
	GameProgression.plus_mode = false
	_start_game()


func _on_StartPlus_button_up() -> void:
	GameProgression.plus_mode = true
	_start_game()


func _start_game():
	_disable_buttons()
	door_area_sprite.hide()
	camera_animator.play("CameraZoomOnDoor")
	ui_elements_fade.play("FadeOut")
	

func _on_CutsceneCameraAnimator_animation_finished(anim_name: String) -> void:
	# Transition scene
	GameControl.goto_scene("res://Scenes/Tutorial.tscn", 1.0)


func _disable_buttons():
	start_button.hide()
	start_plus_button.hide()
	start_button.disabled = true
	start_plus_button.disabled = true


func _on_ScreenFadeAnimator_animation_finished(anim_name: String) -> void:
	screen_fade.queue_free()


func _on_Start_button_down() -> void:
	click_sound.play()
