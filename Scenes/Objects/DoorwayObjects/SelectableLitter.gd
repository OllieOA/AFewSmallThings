extends SelectableItem


func _ready() -> void:
	my_object_name = str(self.get_name())
	wall_location = "Doorway"
	tiltable = true
	
	audio_position_location = self.position
	
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
