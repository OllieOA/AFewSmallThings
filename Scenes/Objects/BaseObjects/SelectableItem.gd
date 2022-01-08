extends Node2D
class_name SelectableItem

signal object_selected
signal show_mouseover
signal stop_mouseover

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
var alert_level1_texture = preload("res://Assets/UI/AlertLevel1.png")
var alert_level2_texture = preload("res://Assets/UI/AlertLevel2.png")

var alert_texture_dict = {
	1: alert_level1_texture,
	2: alert_level2_texture
}

# Base booleans
var selectable: bool
var alertable: bool
var alerting: bool

# Handle alerts
export (int) var min_alert_level
var base_random_chance: int

# Handle metas
var my_object_name: String
var audio_position: Vector2
var wall_location: String
var selectable_nodes_position: Vector2
var global_object

# Handle Sprites
var cursor_sprite: Texture
var alert_sprites: Dictionary
var active_outline_sprite: Sprite


func _ready() -> void:
	# Logic
	selectable = false
	alertable = false
	alerting = false
	base_random_chance = 20

	# Outline
	_hide_outline(base_sprite)
	_hide_outline(active_outline_sprite)

	# Metas
	my_object_name = _register_object_name()
	audio_position = _register_object_audio_position()
	wall_location = _register_wall_location()
	selectable_nodes_position = root_selectable_nodes.position


#	=----------=
#	Handle mouse input
# 	=----------=
func _on_SelectArea_mouse_entered() -> void:
	if selectable:
		if alerting:
			outline_shader_animator.stop()
		# Set shader params
		_show_outline(base_sprite)


func _on_SelectArea_mouse_exited() -> void:
	if alerting:
		var curr_alert_time = alert_animator.get_current_animation_position()
		outline_shader_animator.play()
		outline_shader_animator.seek(curr_alert_time)
	else:
		_hide_outline(base_sprite)


func _on_SelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if selectable:
		if event.is_action_pressed(GameControl.main_input_name):
			emit_signal("object_selected")


func _show_outline(sprite):
	if not sprite == null:
		sprite.material.set_shader_param("intensity", 300)
		sprite.material.set_shader_param("outline_color", Color("dddd28"))
		sprite.material.set_shader_param("outline_color_2", Color("dddd28"))


func _hide_outline(sprite):
	if not sprite == null:
		sprite.material.set_shader_param("intensity", 0)
	

#	=----------=
#	Handle alerting
# 	=----------=
func _play_alert_outline(anim_to_play: String, node: Sprite) -> void:
	pass


func _set_alert(level, node=outline_shader_animator) -> void:
	if level == 3 or level == 0:
		_hide_outline(base_sprite)
		_hide_outline(active_outline_sprite)
		alert_sprite.hide()
		
	elif level in range(1, 3):
		_show_outline(active_outline_sprite)
		var anim_to_play = "BlinkState" + str(level)
		alert_sprite.set_texture(alert_texture_dict[level])
		
		if not alert_sprite.visible:
			alert_sprite.show()
		
		alert_animator.play(anim_to_play)
		node.play(anim_to_play)


func _remove_alert(object_name) -> void:
	EventManager.remove_alert(object_name)
	_set_alert(3)


#	=----------=
#	Handle metas
# 	=----------=
func _register_object_name() -> String:
	return self.get_name()
	

func _register_object_audio_position() -> Vector2:
	return self.position


func _register_wall_location() -> String:
	var curr_root = get_tree().get_root()
	var curr_scene_name = curr_root.get_child(curr_root.get_child_count() - 1).get_name()
	return curr_scene_name
