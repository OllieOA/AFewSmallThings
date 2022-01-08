extends SelectableItem
class_name TiltableItem

signal object_tilted
signal object_untilted

export (NodePath) onready var tilt_sprite = get_node(tilt_sprite) as Sprite
export (NodePath) onready var tilt_sprite_outline_animator = get_node(tilt_sprite_outline_animator) as AnimationPlayer

var tiltable : bool
var tilted : bool
var desired_item : String


#	=----------=
#	Handle ready methods
#	=----------=
func _ready() -> void:
	tiltable = true
	tilted = false
	min_alert_level = 2
	active_outline_sprite = tilt_sprite
	
	if not my_object_name in EventManager.object_dict:
		EventManager.add_object(self)
		
	if my_object_name in EventManager.object_dict:
		var global_object = EventManager.object_dict[my_object_name]
		process_alert(global_object.alert_level, my_object_name)


func process_alert(level: int, object_name: String):
	if tiltable and not tilted:
		if level <= 2:
			tilt(2, object_name)
		else:
			_untilt(true)


#	=----------=
#	Handle object methods
#	=----------=
func tilt(level: int, object_name: String) -> void:
	selectable = true
	tilted = true
	base_sprite.hide()
	tilt_sprite.show()
	alert_animator.play("BlinkState2")
	alert_sprite.show()
	_set_alert(level, tilt_sprite_outline_animator)
	emit_signal("object_tilted")


func _untilt(sprites_only=false) -> void:
	selectable = false
	tilted = false
	base_sprite.show()
	alert_sprite.hide()
	tilt_sprite.hide()
	if not sprites_only:
		_remove_alert(my_object_name)
		if selection_sound.get_stream() != null:
			selection_sound.play()
		emit_signal("object_untilted")


#	=----------=
#	Handle inputs
#	=----------=
func _on_SelectArea_mouse_entered() -> void:
	if selectable:
		tilt_sprite_outline_animator.stop()
		# Set shader params
		_show_outline(tilt_sprite)


func _on_SelectArea_mouse_exited() -> void:
	var curr_alert_time = alert_animator.get_current_animation_position()
	tilt_sprite_outline_animator.play()
	tilt_sprite_outline_animator.seek(curr_alert_time)


func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed(GameControl.main_input_name):
		if tilted:
			if GameControl.cursor_inventory == GameControl.POSS_INVENTS.Empty:
				_untilt()
			else:
				GlobalEvents.play_negative_click()
				# TODO: Tooltip saying to empty cursor

