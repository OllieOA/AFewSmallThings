extends Node2D
class_name PickableItem

signal object_picked
signal object_drop

var pickable : bool
var picked : bool
var dropable : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pick() -> void:
	pass


func drop() -> void:
	pass
