extends SelectableItem
class_name TiltableItem

signal object_tilted
signal object_untilted

export (NodePath) onready var tilt_sprite = get_node(tilt_sprite) as Sprite

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
	
	


func process_alert(level: int, object_name: String):
	if tiltable and not tilted:
		if level <= 2:
			tilt(2, object_name)


#	=----------=
#	Handle object methods
#	=----------=
func tilt(level: int, object_name: String) -> void:
	selectable = true
	tilted = true
	base_sprite.hide()
	tilt_sprite.show()
	alert_animator.play("BlinkState2")
	emit_signal("object_tilted")


func _untilt() -> void:
	selectable = false
	tilted = false
	base_sprite.show()
	tilt_sprite.hide()
	_remove_alert(my_object_name)
	if selection_sound.get_stream() != null:
		selection_sound.play()
	emit_signal("object_untilted")


#	=----------=
#	Handle inputs
#	=----------=
func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed(GameControl.main_input_name):
		if tilted:
			if GameControl.cursor_inventory == null:
				_untilt()
			else:
				GlobalEvents.play_negative_click()
				# TODO: Tooltip saying to empty cursor

