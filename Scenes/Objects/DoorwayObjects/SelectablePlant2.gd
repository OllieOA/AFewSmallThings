extends SelectableItem

onready var flies_animated_sprite = $FliesSprite

func _ready() -> void:
	my_object_name = str(self.get_name())
	wall_location = "Doorway"
	decay_texture_1 = load("res://Assets/Doorway/DoorwayRoom_Plant2_DecayState1.png")
	decay_texture_2 = load("res://Assets/Doorway/DoorwayRoom_Plant2_DecayState2.png")
	outline_alert_level1_texture = load("res://Assets/Doorway/DoorwayRoom_Plant2_AlertLevel1.png")
	outline_alert_level2_texture = load("res://Assets/Doorway/DoorwayRoom_Plant2_AlertLevel2.png")
	
	audio_position_location = self.position
	
	selectable = false
	decayable = true
	alertable = true
	base_random_chance = 100
	
	# Plant can be killed
	flies_animated_sprite.hide()
	flies_animated_sprite.flip_h = true
	self.connect("object_killed", self, "_display_flies", ["Plant2"])

	if not EventManager.object_dict.keys().has(my_object_name):
		if tiltable or decayable or fallable:
			EventManager.add_object(
				my_object_name, 
				alert_level, 
				wall_location, 
				base_random_chance, 
				decayable, 
				tiltable, 
				fallable,
				audio_position_location
			)
	else:
		process_alert(EventManager.object_dict[my_object_name]["alert_level"], my_object_name)

func _display_flies(object_name):
	if object_name == "Plant2":
		flies_animated_sprite.show()
		
