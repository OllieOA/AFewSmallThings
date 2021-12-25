extends Node2D
class_name SelectableItem

signal object_selected

# Nodes
export (NodePath) onready var base_sprite = get_node(base_sprite) as Sprite
export (NodePath) onready var placemat_sprite = get_node(placemat_sprite) as Sprite
export (NodePath) onready var selection_area = get_node(selection_area) as Area2D
export (NodePath) onready var selection_sound = get_node(selection_sound) as AudioStreamPlayer2D

# Base booleans
var selectable : bool
var alertable : bool

# For passing texture to global cursor inventory
var cursor_sprite : Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Logic
	selectable = false
	alertable = false


func _on_SelectArea_mouse_entered() -> void:
	pass # Replace with function body.


func _on_SelectArea_mouse_exited() -> void:
	pass # Replace with function body.
