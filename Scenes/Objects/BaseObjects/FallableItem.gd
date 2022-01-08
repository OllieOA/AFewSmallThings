extends SelectableItem
class_name FallableItem

signal object_falled
signal object_unfalled

export (NodePath) onready var root_fallable_nodes = get_node(root_fallable_nodes) as Node2D
export (NodePath) onready var unfallen_sprite = get_node(unfallen_sprite) as Sprite
export (NodePath) onready var unfallen_placemat_sprite = get_node(unfallen_placemat_sprite) as Sprite
export (NodePath) onready var unfallen_selection_area = get_node(unfallen_selection_area) as Area2D
export (NodePath) onready var unfallen_alert_animator = get_node(unfallen_alert_animator) as AnimationPlayer
export (NodePath) onready var placement_sound = get_node(placement_sound) as AudioStreamPlayer2D

var unfallen_nodes_position: Vector2

var fallable: bool
var fallen: bool
var picked_fallen: bool
var returnable_fallen: bool
var fallen_texture: Texture


#	=----------=
#	Handle ready methods
#	=----------=
func _ready() -> void:
	fallable = true
	fallen = false
	picked_fallen = false
	min_alert_level = 1
	
	# Handle metas
	unfallen_nodes_position = root_fallable_nodes.position
	selection_sound.position = selectable_nodes_position
	placement_sound.position = unfallen_nodes_position
	# TODO: PROCESS_ALERT


func process_alert(level, object_name):
	if fallable and not fallen:
		if level <= 2:
			fall(level, object_name)


#	=----------=
#	Handle object methods
#	=----------=
func fall(level: int, object_name: String):
	base_sprite.show()
	unfallen_sprite.hide()

	var alert_level_to_play = "BlinkState" + str(level)
	alert_animator.play(alert_level_to_play)
	fallen = true
	emit_signal("object_fallen")


func _pick_fallen(level: int):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameControl.cursor_sprite.texture = unfallen_sprite.texture
	GameControl.cursor_sprite.show()
	base_sprite.hide()
	placemat_sprite.show()
	unfallen_placemat_sprite.show()
	
	# Feedback
	var alert_level_to_play = "BlinkState" + str(level)
	unfallen_alert_animator.play(alert_level_to_play)
	selection_sound.play()
	
	# Handle inventory
	GameControl.cursor_inventory = my_object_name
	picked_fallen = true


func _drop():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameControl.cursor_sprite.hide()
	GameControl.cursor_sprite.texture = null
	GameControl.cursor_inventory = null
	base_sprite.show()
	placemat_sprite.hide()
	unfallen_placemat_sprite.hide()
	unfallen_alert_animator.stop()
	
	GameControl.cursor_inventory = null
	picked_fallen = false


func _deliver():
	if returnable_fallen:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameControl.cursor_sprite.hide()
		GameControl.cursor_sprite.texture = null
		GameControl.cursor_inventory = null
		
		# Handle sprites
		placemat_sprite.hide()
		unfallen_placemat_sprite.hide()
		picked_fallen = false
		_remove_alert(my_object_name)
		placement_sound.play()
		emit_signal("object_unfalled")
	else:
		# Tooltip to fix the shelf?
		pass


#	=----------=
#	Handle inputs
#	=----------=
func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# PICK
	if event.is_action_pressed(GameControl.main_input_name):
		if fallen:
			if GameControl.cursor_inventory == null:
				_pick_fallen(EventManager.object_dict[my_object_name])
			else:
				GlobalEvents.play_negative_click()
				# Tooltip saying to empty cursor


func _on_UnfallenArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if GameControl.cursor_inventory == my_object_name:
		_deliver()


func _on_UnfallenArea_mouse_entered() -> void:
	if GameControl.cursor_inventory == my_object_name:
		_show_outline_unfalled(true)


func _on_UnfallenArea_mouse_exited() -> void:
	if GameControl.cursor_inventory == my_object_name:
		_show_outline_unfalled(false)


func _show_outline_unfalled(show: bool):
	if show:
		unfallen_placemat_sprite.material.set_shader_param("intensity", 300)
		unfallen_placemat_sprite.material.set_shader_param("outline_color", Color("dddd28"))
		unfallen_placemat_sprite.material.set_shader_param("outline_color_2", Color("dddd28"))
	else:
		unfallen_placemat_sprite.material.set_shader_param("intensity", 0)
