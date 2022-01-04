extends Node2D
class_name SelectableItem

signal object_selected

# Nodes
export(NodePath) onready var root_selectable_nodes = get_node(root_selectable_nodes) as Node2D
export(NodePath) onready var base_sprite = get_node(base_sprite) as Sprite
export(NodePath) onready var alert_sprite = get_node(alert_sprite) as Sprite
export(NodePath) onready var placemat_sprite = get_node(placemat_sprite) as Sprite
export(NodePath) onready var selection_area = get_node(selection_area) as Area2D
export(NodePath) onready var selection_sound = get_node(selection_sound) as AudioStreamPlayer2D
export(NodePath) onready var outline_shader_animator = get_node(outline_shader_animator) as AnimationPlayer
export(NodePath) onready var alert_animator = get_node(alert_animator) as AnimationPlayer

# Textures
export(Texture) onready var alert_level1_texture = load(str(alert_level1_texture)) as Texture
export(Texture) onready var alert_level2_texture = load(str(alert_level2_texture)) as Texture

var alert_texture_dict = {
	1: alert_level1_texture,
	2: alert_level2_texture
}

# Base booleans
var selectable: bool
var alertable: bool
var alerting: bool

# Handle alerts
var alert_level: int
var min_alert_level: int
var base_random_chance: int

# Handle metas
var my_object_name: String
var audio_position: Vector2
var wall_location: String
var selectable_nodes_position: Vector2

# Handle Sprites
var cursor_sprite: Texture
var alert_sprites: Dictionary


func _ready() -> void:
	# Logic
	selectable = false
	alertable = false
	alerting = false

	# Sprites
	alert_sprites = {1: alert_level1_texture, 2: alert_level2_texture}

	# Outline
	_show_outline(false)

	# Metas
	my_object_name = _register_object_name()
	audio_position = _register_object_audio_position()
	wall_location = _register_wall_location()
	selectable_nodes_position = root_selectable_nodes.position
	
	if not my_object_name in EventManager.object_dict:
		EventManager.add_object(self)
	else:
		var global_object = EventManager.object_dict[my_object_name]
		process_alert(global_object.alert_level, my_object_name)


func process_alert(level: int, object_name: String):
	# Extended in each inherited class
	# No functionality intended at this level
	pass


#	=----------=
#	Handle mouse input
# 	=----------=
func _on_SelectArea_mouse_entered() -> void:
	if selectable:
		if alerting:
			outline_shader_animator.stop()
		# Set shader params
		_show_outline(true)


func _on_SelectArea_mouse_exited() -> void:
	if alerting:
		var curr_alert_time = alert_animator.get_current_animation_position()
		outline_shader_animator.play()
		outline_shader_animator.seek(curr_alert_time)
	else:
		_show_outline(false)


func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if selectable:
		if event.is_action_pressed(GameControl.main_input_name):
			emit_signal("object_selected")


func _show_outline(show: bool):
	if show:
		base_sprite.material.set_shader_param("intensity", 300)
		base_sprite.material.set_shader_param("outline_color", Color("dddd28"))
		base_sprite.material.set_shader_param("outline_color_2", Color("dddd28"))
	else:
		base_sprite.material.set_shader_param("intensity", 0)


#	=----------=
#	Handle alerting
# 	=----------=
func _set_alert(level) -> void:
	if level == 3 or level == 0:
		_show_outline(false)
		alert_sprite.hide()
	elif level in range(1, 3):
		var anim_to_play = "BlinkState" + str(level)
		var alert_texture_to_show = alert_texture_dict[level]

		if not alert_sprite.visbile:
			alert_sprite.show()
			
		alert_animator.play(anim_to_play)
		outline_shader_animator.play(anim_to_play)


func _remove_alert(object_name) -> void:
	alert_level = 3
	var curr_data_object = EventManager.object_dict[object_name]
	curr_data_object.alert_level = alert_level
	curr_data_object.random_chance = curr_data_object.base_random_chance


#	=----------=
#	Handle metas
# 	=----------=
func _register_object_name() -> String:
	return self.get_name()
	

func _register_object_audio_position() -> Vector2:
	return self.position


func _register_wall_location() -> String:
	return get_tree().get_root().get_name()
