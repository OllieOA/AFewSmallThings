extends SelectableItem
class_name DecayableItem

signal object_decayed
signal object_undecayed
signal object_killed

export (NodePath) onready var decay_sprite = get_node(decay_sprite) as Sprite
export (NodePath) onready var decay_sprite_outline_animator = get_node(decay_sprite_outline_animator) as AnimationPlayer
export (NodePath) onready var kill_sprite_animation = get_node(kill_sprite_animation) as AnimatedSprite
export (Texture) onready var decay_texture_0 = load(str(decay_texture_0.resource_path))
export (Texture) onready var decay_texture_1 = load(str(decay_texture_1.resource_path))
export (Texture) onready var decay_texture_2 = load(str(decay_texture_2.resource_path))
var texture_dict

var decayable : bool
var killable : bool
var killed : bool

export (GameControl.POSS_INVENTS) var desired_inventory = GameControl.POSS_INVENTS.Empty


func _ready() -> void:
	texture_dict = {
		2: decay_texture_2,
		1: decay_texture_1,
		0: decay_texture_0
		}
		
	decayable = true
	killable = true
	killed = false
	
	active_outline_sprite = decay_sprite

	if not my_object_name in EventManager.object_dict:
		EventManager.add_object(self)
		
	if my_object_name in EventManager.object_dict:
		var global_object = EventManager.object_dict[my_object_name]
		process_alert(global_object.alert_level, my_object_name)


func process_alert(level: int, object_name: String):
	if level < 3:
		decay(level, object_name)
	elif level == 3:
		# Restore 
		_undecay(true)


#	=----------=
#	Handle object methods
#	=----------=
func decay(level: int, object_name: String) -> void:
	if level > 0:
		_decay(level)
	elif level <= 0:
		# Killed
		if killable:
			_kill_object()


func _decay(level) -> void:
	kill_sprite_animation.hide()
	selectable = true
	decay_sprite.set_texture(texture_dict[level])
	alert_sprite.show()
	decay_sprite.show()
	base_sprite.hide()
	_set_alert(level, decay_sprite_outline_animator)
	emit_signal("object_decayed")


func _undecay(sprites_only=false) -> void:
	selectable = false
	kill_sprite_animation.hide()
	decay_sprite.hide()
	base_sprite.show()
	_remove_alert(my_object_name)
	if not sprites_only:
		if selection_sound.get_stream() != null:
			selection_sound.play()
		emit_signal("object_undecayed")


func _kill_object() -> void:
	selectable = false
	killed = true
	decay_sprite.set_texture(texture_dict[0])
	decay_sprite.show()
	base_sprite.hide()
	kill_sprite_animation.show()
	kill_sprite_animation.play()
	_set_alert(0)
	
	# Remove from global object list
	EventManager.object_dict[my_object_name].object_active = false
	killed = true
	emit_signal("object_killed")


#	=----------=
#	Handle inputs - overwrite base methods
#	=----------=
func _on_SelectArea_mouse_entered() -> void:
	if selectable:
		decay_sprite_outline_animator.stop()
		# Set shader params
		_show_outline(decay_sprite)


func _on_SelectArea_mouse_exited() -> void:
	var curr_alert_time = alert_animator.get_current_animation_position()
	decay_sprite_outline_animator.play()
	decay_sprite_outline_animator.seek(curr_alert_time)


func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed(GameControl.main_input_name):
		if EventManager.object_dict[my_object_name].alert_level in range(1, 3):
			if GameControl.cursor_inventory == desired_inventory:
				_undecay()
			else:
				GlobalEvents.play_negative_click()
				# Tooltip saying to empty cursor

