extends SelectableItem
class_name DecayableItem

signal object_decayed
signal object_undecayed
signal object_killed

export (NodePath) onready var decay_sprite = get_node(decay_sprite) as Sprite
export (NodePath) onready var kill_sprite_animation = get_node(kill_sprite_animation) as AnimatedSprite
export (Texture) onready var decay_texture_1 = load(str(decay_texture_1)) as Texture
export (Texture) onready var decay_texture_2 = load(str(decay_texture_2)) as Texture
var decay_texture_0 = decay_texture_1.copy()

var texture_dict = {
	2: decay_texture_2,
	1: decay_texture_1,
	0: decay_texture_0
}

var decayable : bool
var killable : bool
var killed : bool

var desired_inventory : String


func _ready() -> void:
	decayable = true
	killable = true
	killed = false
	min_alert_level = 0


func process_alert(level: int, object_name: String):
	if level < 3:
		decay(level, object_name)
	else:
		# Restore 
		decay_sprite.hide()
		base_sprite.show()
		alert_animator.stop()
		selectable = false


#	=----------=
#	Handle object methods
#	=----------=
func decay(level: int, object_name: String) -> void:
	if level > 0:
		_decay(level)
	elif level <= 0:
		# Killed
		_kill_object()


func _decay(level) -> void:
	selectable = true
	decay_sprite.texture = texture_dict[level]
	alert_animator.play(("BlinkState" + str(level)))
	decay_sprite.show()
	base_sprite.hide()
	emit_signal("object_decayed")


func _undecay() -> void:
	selectable = false
	decay_sprite.hide()
	base_sprite.show()
	_remove_alert(my_object_name)
	emit_signal("object_undecayed")


func _kill_object() -> void:
	selectable = false
	decay_sprite.texture = texture_dict[0]
	decay_sprite.show()
	base_sprite.hide()
	
	# Remove from global object list
	EventManager.object_dict[my_object_name].active = false
	killed = true
	emit_signal("object_killed")


#	=----------=
#	Handle inputs
#	=----------=
func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed(GameControl.main_input_name):
		if alert_level in range(1, 3):
			if GameControl.cursor_inventory == desired_inventory:
				_undecay()
			else:
				GlobalEvents.play_negative_click()
				# Tooltip saying to empty cursor
