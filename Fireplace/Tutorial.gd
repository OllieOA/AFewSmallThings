extends Node2D

# Get references
# Audio and UI
onready var ambient_audio = $Ambient
onready var ambient_audio_fade = $Ambient/AudioFade
# Objects
onready var rock_1 = $GameObjects/SelectableRock1
onready var rock_2 = $GameObjects/SelectableRock2
onready var logs = $GameObjects/SelectableLogs
onready var door = $GameObjects/SelectableTutorialDoor

# Extras
var keyhole_selectable
onready var keyhole_marker_sprite = $GameObjects/SelectableKeyHole/KeyHole/KeyHoleMarker
onready var keyhole_alert_animator = $GameObjects/SelectableKeyHole/KeyHole/KeyHoleAlert/KeyHoleAlertAnimator
onready var keyhole_alert_sprite = $GameObjects/SelectableKeyHole/KeyHole/KeyHoleAlert
var keyhole_alert_level_2 = preload("res://Assets/Tutorial/TutorialSceneKeyholeAlertLevel2.png")
var keyhole_alert_level_1 = preload("res://Assets/Tutorial/TutorialSceneKeyholeAlertLevel1.png")
onready var fire_animator = $FireplaceLight/FirelightRandomness
var tooltip_3_advanced
var door_knock_sound = preload("res://Sounds/DoorKnock.ogg")
var door_open_sound = preload("res://Sounds/DoorOpening.ogg")

# Tooltips
onready var tooltip_container = $Tooltips
export (NodePath) onready var tooltip_1 = get_node(tooltip_1) as MarginContainer
export (NodePath) onready var tooltip_2 = get_node(tooltip_2) as MarginContainer
export (NodePath) onready var tooltip_3 = get_node(tooltip_3) as MarginContainer
export (NodePath) onready var tooltip_4 = get_node(tooltip_4) as MarginContainer
export (NodePath) onready var tooltip_5 = get_node(tooltip_5) as MarginContainer
onready var tooltip_animator = $Tooltips/TooltipAnimator

# Texts
onready var text_container = $TextPrompts
export (NodePath) onready var text_1 = get_node(text_1) as MarginContainer
export (NodePath) onready var text_2 = get_node(text_2) as MarginContainer
onready var text_animator = $TextPrompts/TextAnimator
onready var text_audio = $TextPrompts/AudioText

# UI Elements
export (NodePath) onready var settings_button = get_node(settings_button) as TextureButton
export (NodePath) onready var settings_button_tooltip = get_node(settings_button_tooltip) as NinePatchRect
onready var alert_level_1 = $AlertLevel1Notification 
onready var alert_level_2 = $AlertLevel2Notification 

# Get logic
var tutorial_passed
var rock_1_selected_latch
var rock_2_selected_latch
var door_knock_latch


func _ready() -> void:
	tutorial_passed = false
	tooltip_3_advanced = false
	
	door.connect("object_selected", self, "_door_knocked_on")
	door.select_audio.stream = door_knock_sound
	
	rock_1_selected_latch = false
	rock_1.selectable = false
	rock_1.connect("object_picked", self, "_rock_selected", [rock_1])
	rock_2_selected_latch = false
	rock_2.selectable = false
	rock_2.connect("object_picked", self, "_rock_selected", [rock_2])
	
	logs.selectable = false
	logs.connect("object_extracted", self, "_on_Key_extracted_event")
	
	# Extra elements
	fire_animator.play("FlameFlicker")
	keyhole_alert_sprite.texture = keyhole_alert_level_2
	keyhole_selectable = false
	keyhole_alert_sprite.hide()
	keyhole_marker_sprite.hide()
	ambient_audio.play()
	
	# Tooltip management
	tooltip_container.modulate.a = 1
	
	tooltip_1.modulate.a = 0
	tooltip_2.modulate.a = 0
	tooltip_3.modulate.a = 0
	tooltip_4.modulate.a = 0
	tooltip_5.modulate.a = 0
	
	# Text managements
	text_container.modulate.a = 1
	text_1.modulate.a = 0
	text_2.modulate.a = 0
	
	# UI elements
	settings_button_tooltip.hide()
	
	# Start initial dialogue
	# emit signal when done, show tooltip
	_set_animation_and_play_tooltip(tooltip_1)
	yield(tooltip_animator, "animation_finished")
	door.selectable = true

# KEYHOLE
func _on_KeyHole_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Hacky logic, but that is fine as this isn't really used much
	if logs.extracted:
		if event.is_action_pressed("MainAction"):
			keyhole_marker_sprite.hide()
			keyhole_alert_sprite.hide()
			keyhole_selectable = false
			_unlock_door()
			logs._drop()


func _on_KeyHole_mouse_entered() -> void:
	if keyhole_selectable:
		keyhole_marker_sprite.show()


func _on_KeyHole_mouse_exited() -> void:
	keyhole_marker_sprite.hide()


# Manage game logic
func _set_animation_and_play_tooltip(tooltip, forwards=true):
	tooltip_animator.set_root(tooltip.get_path())
	if forwards:
		tooltip_animator.play("Fade")
	else:
		tooltip_animator.play_backwards("Fade")


func _set_animation_and_play_text(text, forwards=true):
	text_animator.set_root(text.get_path())
	if forwards:
		text_animator.play("FadeInPopUp")
		text_audio.play()
	else:
		text_animator.play("FadeOutPopUp")


func _door_knocked_on():
	if not tutorial_passed:
		door.selectable = false
		door.outline_selection_sprite.hide()
		rock_1.selectable = true
		rock_2.selectable = true
		
		keyhole_alert_sprite.show()
		keyhole_alert_animator.play("BlinkState2")
		_play_notification(keyhole_alert_sprite, 2)
		_set_animation_and_play_tooltip(tooltip_1, false)
		yield(tooltip_animator, "animation_finished")
		_set_animation_and_play_tooltip(tooltip_2)
		yield(tooltip_animator, "animation_finished")
		_set_animation_and_play_text(text_1)
		yield(text_animator, "animation_finished")
	else:
		door.selectable = false
		door.outline_selection_sprite.hide()
		door.select_audio.stream = door_open_sound
		# Play audio
		GameControl.goto_scene("res://Scenes/Doorway.tscn")
	
	
func _on_Key_extracted_event():
	logs.selectable = false
	keyhole_selectable = true
	keyhole_alert_sprite.texture = keyhole_alert_level_1
	
	alert_level_1.play()
	keyhole_alert_animator.play("BlinkState1")
	_play_notification(keyhole_alert_sprite, 1)
	_set_animation_and_play_text(text_2, false)
	yield(text_animator, "animation_finished")
	_set_animation_and_play_tooltip(tooltip_4, false)
	yield(tooltip_animator, "animation_finished")
	_set_animation_and_play_tooltip(tooltip_5)
	yield(tooltip_animator, "animation_finished")


func _rock_selected(rock):
	if rock == rock_1:
		rock_1_selected_latch = true
	elif rock == rock_2:
		rock_2_selected_latch = true
	_unlock_logs()


func _unlock_logs():
	if rock_1_selected_latch and rock_2_selected_latch:
		rock_1.selectable = false
		rock_2.selectable = false
		logs.selectable = true
		_set_animation_and_play_tooltip(tooltip_3, false)
		yield(tooltip_animator, "animation_finished")
		_set_animation_and_play_tooltip(tooltip_4)
		yield(tooltip_animator, "animation_finished")
		_set_animation_and_play_text(text_2)
		yield(text_animator, "animation_finished")
		
	elif not tooltip_3_advanced:
		tooltip_3_advanced = true
		
		_set_animation_and_play_tooltip(tooltip_2, false)
		yield(tooltip_animator, "animation_finished")
		_set_animation_and_play_tooltip(tooltip_3)
		yield(tooltip_animator, "animation_finished")
		_set_animation_and_play_text(text_1, false)
		yield(text_animator, "animation_finished")
		

func _unlock_door():
	tutorial_passed = true
	door.outline_selection_sprite.show()
	_set_animation_and_play_tooltip(tooltip_5, false)
	yield(tooltip_animator, "animation_finished")
	door.selectable = true
	

# UI Elements

func _on_SettingsButton_mouse_entered() -> void:
	settings_button_tooltip.show()


func _on_SettingsButton_mouse_exited() -> void:
	settings_button_tooltip.hide()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("Skip"):
		GameControl.goto_scene("res://Scenes/Doorway.tscn")
		door.selectable = false
		rock_1.selectable = false
		rock_2.selectable = false
		logs.selectable = false
		keyhole_selectable = false
		
func _play_notification(object, level):
	if level == 2:
		alert_level_2.position = object.get_global_position()
		alert_level_2.play()
	elif level == 1:
		alert_level_1.position = object.get_global_position()
		alert_level_1.play()
		
