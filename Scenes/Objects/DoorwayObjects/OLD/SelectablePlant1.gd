extends SelectableItem

onready var flies_animated_sprite = $FliesSprite

func _ready() -> void:
	desired_item = "SelectableWateringCan"
	my_object_name = str(self.get_name())
	wall_location = "Doorway"
	decay_texture_1 = load("res://Assets/Doorway/DoorwayRoom_Plant1_DecayState1.png")
	decay_texture_2 = load("res://Assets/Doorway/DoorwayRoom_Plant1_DecayState2.png")
	outline_alert_level1_texture = load("res://Assets/Doorway/DoorwayRoom_Plant1_AlertLevel1.png")
	outline_alert_level2_texture = load("res://Assets/Doorway/DoorwayRoom_Plant1_AlertLevel2.png")
	
	audio_position_location = self.position
	
	# Check if these are not in global_object_dict
	selectable = false
	decayable = true
	alertable = true
	
	# Plant can be killed
	flies_animated_sprite.hide()
	self.connect("object_killed", self, "_display_flies", ["Plant1"])
	
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
	if object_name == "Plant1":
		flies_animated_sprite.show()
		
		
