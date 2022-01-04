extends SelectableItem
class_name PickableItem

signal object_picked
signal object_drop

var pickable : bool
var picked : bool
var dropable : bool


func _ready() -> void:
	pickable = false
	picked = false
	dropable = false

#	=----------=
#	Handle object methods
# 	=----------=
func pick() -> void:
	# Handle pick visibility
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameControl.cursor_sprite.texture = base_sprite.texture
	GameControl.cursor_sprite.show()
	base_sprite.hide()
	placemat_sprite.show()
	
	# Handle inventory
	GameControl.cursor_inventory = self.get_name()
	picked = true


func drop() -> void:
	# Handle drop visibility
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameControl.cursor_sprite.hide()
	GameControl.cursor_sprite.texture = null
	base_sprite.show()
	placemat_sprite.hide()
	
	# Handle inventory
	GameControl.cursor_inventory = null
	picked = false


#	=----------=
#	Handle inputs
# 	=----------=
func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed(GameControl.main_input_name):
		if pickable and not picked:
			pick()
		elif picked:
			drop()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(GameControl.cancel_input_name) and picked:
		drop()


