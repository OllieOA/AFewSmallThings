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
onready var keyhole_marker_sprite = $GameObjects/KeyHole/KeyHoleMarker
onready var keyhole_marker_animator = $GameObjects/KeyHole/KeyHoleMarker/KeyHoleMarkerAnimator
onready var fire_animator = $FireplaceLight/FirelightRandomness
onready var door_marker_sprite = $GameObjects/SelectableDoor/DoorArea/DoorMarker

# Tooltips
onready var tooltip_1 = $Tooltips/Tooltip1
onready var tooltip_2 = $Tooltips/Tooltip2
onready var tooltip_3 = $Tooltips/Tooltip3
onready var tooltip_4 = $Tooltips/Tooltip4
onready var tooltip_5 = $Tooltips/Tooltip5

onready var tooltip_animator = $Tooltips/TooltipAnimator

# Get logic
var tutorial_passed
var rock_1_selected_latch
var rock_2_selected_latch
var door_knock_latch


func _ready() -> void:
	tutorial_passed = false
	
	door_knock_latch = false
	door.connect("object_selected", self, "_door_knocked_on")
	
	rock_1_selected_latch = false
	rock_1.connect("object_picked", self, "_rock_1_selected")
	rock_2_selected_latch = false
	rock_2.connect("object_picked", self, "_rock_2_selected")
	
	logs.selectable = false
	logs.connect("object_extracted", self, "_on_Key_extracted_event")
#	keyhole_marker_animator.play("blink")
	
	# Extra elements
	fire_animator.play("FlameFlicker")
	ambient_audio.play()
	
	# Start initial dialogue
	# emit signal when done, show tooltip
	

func _on_KeyHole_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Hacky logic, but that is fine as this isn't really used much
	if logs.extracted:
		if event.is_action_pressed("MainAction"):
			keyhole_marker_sprite.hide()
			_unlock_door()
			logs.drop()


# Manage game logic
func _door_knocked_on():
	door.selectable = false
	rock_1.selectable = true
	rock_2.selectable = true
	# TODO: Show tooltip 2

func _on_Key_extracted_event():
	keyhole_marker_animator.play("BlinkState1")


func _rock_1_selected():
	rock_1_selected_latch = true
	_unlock_logs()


func _rock_2_selected():
	rock_2_selected_latch = true
	_unlock_logs()

	
func _unlock_logs():
	if rock_1_selected_latch and rock_1_selected_latch:
		logs.selectable = true
		# Self dialogue
		
func _unlock_door():
	pass
	
	
