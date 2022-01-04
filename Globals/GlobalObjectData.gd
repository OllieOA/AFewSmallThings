extends Node
class_name GlobalObjectData

#{
#	"alert_level": 3, 
#	"base_random_chance": object.base_random_chance,
#	"random_chance": object.base_random_chance, 
#	"wall_location": object.wall_location, 
#	"object_alertable": true,
#	"object_active": true,
#	"object_position": object.get_global_position(),
#	}

var object_name: String
var alert_level: int
var base_random_chance: int
var random_chance: int
var wall_location: String
var object_alertable: bool
var object_active: bool
var object_position: Vector2
var object_min_alert_level: int


func _ready() -> void:
	object_name = ""
	alert_level = 3
	base_random_chance = 0
	random_chance = 0
	wall_location = ""
	object_alertable = true
	object_active = true
	object_position = Vector2(0.0, 0.0)
	object_min_alert_level = 3
