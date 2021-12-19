class_name SelectableItem

extends Node2D

signal object_selected
signal object_dropped
signal object_extracted
signal object_picked
signal object_fallen
signal object_decayed
signal object_undecayed
signal object_restored
signal object_untilted
signal object_tilted
signal object_delivered_to
signal object_killed
signal object_random_update

""" Item object types are:
	- Pickable (i.e. can be picked up (e.g. broom))
	- Extractable (i.e. something can be pulled from it (e.g. pile of logs)
	- Acceptable (i.e. something can be given to it (e.g. fireplace receiving logs))
	- Fallable (i.e. can fall down (baubles))
	- Tiltable (i.e. can tilt (e.g. pictures, shelves))
	- Decayable (i.e. can decay into 3 other states)
"""

var selectable : bool
var pickable : bool
var picked : bool
var dropable : bool
var extractable : bool
var extracted : bool
var fallable : bool
var fallen : bool
var decayable : bool
var dead_latch : bool
var num_decay_states : int
var tiltable : bool
var tilted : bool
var acceptable : bool
var alertable : bool
var alert_level : int
var base_random_chance : int
var wall_location

var my_object_name

# Sprites
onready var base_sprite = $Base
onready var outline_alert_sprite = $OutlineAlert
onready var outline_selection_sprite = $OutlineSelection
onready var placemat_sprite = $Placemat
onready var decay_sprite = $DecaySprite
onready var tilt_sprite = $TiltSprite
onready var cursor_sprite = $Cursor
var outline_alert_level1_texture
var outline_alert_level2_texture
var decay_texture_1
var decay_texture_2

# Animators
onready var alert_animator = $OutlineAlert/OutlineAlertAnimation
onready var delivery_animator = $DeliveryPlacemat/DeliveryPromptAnimation

# Sounds
onready var select_audio = $SelectSound
onready var drop_audio = $DropSound
onready var alert_level1_audio = preload("res://Sounds/AlertLevel1.ogg")
onready var alert_level2_audio = preload("res://Sounds/AlertLevel2.ogg")
var audio_position_location

# Areas
onready var selection_area = $SelectArea
onready var delivery_area = $DeliveryArea


func _ready() -> void:
	# Set up default logic
	selectable = false
	pickable = false
	picked = false
	dropable = false
	extractable = false
	extracted = false
	fallable = false
	fallen = false
	decayable = false
	dead_latch = false
	num_decay_states = false
	tiltable = false
	tilted = false
	acceptable = false
	alert_level = 3
	alertable = false
	
	# Set up sprite stuff
	outline_alert_sprite.hide()
	outline_selection_sprite.hide()
	placemat_sprite.hide()
	decay_sprite.hide()
	tilt_sprite.hide()
	cursor_sprite.hide()
	cursor_sprite.z_index = 10
	
	var CURSOR_SPRITE_COLOR = Color("b4ffffff")
	cursor_sprite.modulate = CURSOR_SPRITE_COLOR
	cursor_sprite.centered = true
	
	var OUTLINE_SPRITE_COLOR = Color("fbf236")
	outline_selection_sprite.modulate = OUTLINE_SPRITE_COLOR
	
	# Set up audio
	select_audio.position = selection_area.position
	drop_audio.position = selection_area.position


func _process(delta: float) -> void:
	if picked or extracted:
		cursor_sprite.position = get_local_mouse_position()


func process_alert(level, object_name):
	print("PROCESSING ALERT")
	if decayable:
		if level == 2:
			_decay(level, object_name)
			if GameControl.current_scene_name == wall_location:
				EventManager.play_notification_level(2, audio_position_location)
		elif level == 1:
			_decay(level, object_name)
			if GameControl.current_scene_name == wall_location:
				EventManager.play_notification_level(1, audio_position_location)
		elif level <= 0 and not dead_latch:
			dead_latch = true
			_kill_object()
			if GameControl.current_scene_name == wall_location:
				EventManager.play_notification_level(0, audio_position_location)
	elif tiltable:
		if level <= 2:
			_tilt(2)
			
			
		
	elif fallable:
		pass


# Handle mouseover
func _on_SelectArea_mouse_entered() -> void:
	if selectable:
		if pickable or extractable:
			if (not picked and pickable) or (not extracted and extractable):
				if GameControl.cursor_inventory == null:
					outline_selection_sprite.show()
		else:
			# Purely base selectable - no other behaviour
			outline_selection_sprite.show()


func _on_SelectArea_mouse_exited() -> void:
	if (not picked and pickable) or (not extracted and extractable):
		outline_selection_sprite.hide()
	else:
		# Purely base selectable - no other behaviour
		outline_selection_sprite.hide()
			

# Handle inventory
func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if selectable:
		if event.is_action_pressed("MainAction"):
			if pickable and GameControl.cursor_inventory == null:
				_pickup()
			elif picked and GameControl.cursor_inventory == self.get_name():
				_drop()
			elif extractable and GameControl.cursor_inventory == null:
				_extract()
			elif tilted:
				_untilt()
			elif GameControl.cursor_inventory == null:
				_select()
	elif not selectable and picked and GameControl.cursor_inventory == self.get_name():
		if event.is_action_pressed("MainAction"):
			_drop()
		

func _unhandled_input(event: InputEvent) -> void:	
	if picked and GameControl.cursor_inventory != null:
		if event.is_action_released("CancelAction") and dropable:
			_drop()
	
	
# Manipulation methods
func _pickup():
	# Handle logic
	GameControl.cursor_inventory = self.get_name()
	picked = true
	pickable = false
	
	# Play sound
	if select_audio.get_stream() != null:
		select_audio.play()
	
	# Manage sprites
	base_sprite.hide()
	outline_selection_sprite.hide()
	outline_alert_sprite.hide()
	placemat_sprite.show()
	
	# Manage cursor
	cursor_sprite.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("object_picked")
	
	
func _extract():
	GameControl.cursor_inventory = self.get_name()
	extracted = true
	
	# Manage sprites
	outline_selection_sprite.hide()
	
	# Play sound
	if select_audio.get_stream() != null:
		select_audio.play()
	
	# Manage cursor
	cursor_sprite.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("object_extracted")
	

func _drop():
	# Handle logic
	GameControl.cursor_inventory = null
	picked = false
	pickable = true
	
	# Play sound
	if drop_audio.get_stream() != null:
		drop_audio.play()
	
	# Manage sprites
	base_sprite.show()
	placemat_sprite.hide()
	
	# Manage cursor
	cursor_sprite.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("object_dropped")


func _select():
	# Play sound
	if select_audio.get_stream() != null:
		select_audio.play()
	emit_signal("object_selected")


#func tilt():
#	selectable = true
#	tilted = true
##	alert_level = 2
#	_on_alert_increase()
#	tilt_sprite.show()
#	base_sprite.hide()
#	if drop_audio.get_stream() != null:
#		drop_audio.play()
#	emit_signal("object_tilted")


func _tilt(level):
	selectable = true
	base_sprite.hide()
	tilt_sprite.show()
	outline_alert_sprite.show()
	alert_animator.play("BlinkState1")	
	
	
func _untilt():
	selectable = false
	tilted = false
	base_sprite.show()
	tilt_sprite.hide()
	if select_audio.get_stream() != null:
		select_audio.play()
	emit_signal("object_untilted")


func _decay(level, object_name):
	selectable = true
	if level == 2:
		decay_sprite.texture = decay_texture_2
		outline_alert_sprite.texture = outline_alert_level2_texture
		alert_animator.play("BlinkState2")
	elif level == 1:
		decay_sprite.texture = decay_texture_1
		outline_alert_sprite.texture = outline_alert_level1_texture
		alert_animator.play("BlinkState1")
	decay_sprite.show()
	base_sprite.hide()
	outline_alert_sprite.show()
	EventManager.alert_cooldown_start(object_name)
	emit_signal("object_decayed")


func _undecay():
	selectable = false
	decay_sprite.hide()
	base_sprite.show()
	_remove_alert()
	emit_signal("object_undecayed")


func fall():
	pass


func _remove_alert():
	alert_level = 3
	outline_alert_sprite.hide()
	EventManager.object_dict[self]["alert_level"] = 3
	EventManager.object_dict[self]["alertable"] = false
	EventManager.alert_cooldown_start(my_object_name)
	

func _kill_object():
	selectable = false
	outline_alert_sprite.hide()
	outline_selection_sprite.hide()
	decay_sprite.texture = decay_texture_1
	decay_sprite.show()
	base_sprite.hide()
	
	# Remove from global object list
	EventManager.object_dict[my_object_name]["object_decayable"] = false
	EventManager.object_dict[my_object_name]["object_fallable"] = false
	EventManager.object_dict[my_object_name]["object_tiltable"] = false
	
	emit_signal("object_killed")

