class_name SelectableItem

extends Node2D

signal object_selected
signal object_dropped
signal object_extracted
signal object_picked
signal object_fallen
signal object_decayed
signal object_restored
signal object_untilted
signal object_delivered_to

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
var decay_state : int
var num_decay_states : int
var tiltable : bool
var tilted : bool
var acceptable : bool

onready var base_sprite = $Base
onready var outline_alert_sprite = $OutlineAlert
onready var outline_selection_sprite = $OutlineSelection
onready var placemat_sprite = $Placemat
onready var decay_sprite = $DecaySprite
onready var tilt_sprite = $TiltSprite
onready var cursor_sprite = $Cursor


func _ready() -> void:
	# Set up default logic
	var selectable = false
	var pickable = false
	var picked = false
	var dropable = false
	var extractable = false
	var extracted = false
	var fallable = false
	var fallen = false
	var decayable = false
	var decay_state = 0
	var num_decay_states = false
	var tiltable = false
	var tilted = false
	var acceptable = false
	
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
	
	var OUTLINE_SPRITE_COLOR = Color("d3de0e")
	outline_selection_sprite.modulate = OUTLINE_SPRITE_COLOR

func _process(delta: float) -> void:
	if picked or extracted:
		cursor_sprite.position = get_local_mouse_position()


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
	if selectable:
		if (not picked and pickable) or (not extracted and extractable):
			outline_selection_sprite.hide()
		else:
			# Purely base selectable - no other behaviour
			outline_selection_sprite.hide()
			


# Handle inventory
func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if selectable:
		emit_signal("object_selected")
		if pickable and GameControl.cursor_inventory == null:
			if event.is_action_pressed("MainAction"):
				_pickup()
		# Put back down (gracefully)
		elif picked and GameControl.cursor_inventory == self.get_name():
			if event.is_action_pressed("MainAction"):
				drop()
		# Special extract method
		elif extractable and GameControl.cursor_inventory == null:
			if event.is_action_pressed("MainAction"):
				_extract()

func _unhandled_input(event: InputEvent) -> void:	
	if picked and GameControl.cursor_inventory != null:
		if event.is_action_released("CancelAction") and dropable:
			drop()
	
	
# Manipulation methods
func _pickup():
	# Handle logic
	GameControl.cursor_inventory = self.get_name()
	picked = true
	pickable = false
	
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
	
	# Manage cursor
	cursor_sprite.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("object_extracted")
	

func drop():
	# Handle logic
	GameControl.cursor_inventory = null
	picked = false
	pickable = true
	
	# Manage sprites
	base_sprite.show()
	placemat_sprite.hide()
	
	# Manage cursor
	cursor_sprite.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("object_dropped")
