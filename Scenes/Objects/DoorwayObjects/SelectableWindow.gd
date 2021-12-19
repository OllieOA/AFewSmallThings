extends SelectableItem

var event_sound = preload("res://Sounds/WindowOpening.ogg")

func _ready() -> void:
	my_object_name = str(self.get_name())
	wall_location = "Doorway"
	tiltable = true
	self.connect("object_tilted", self, "_play_wind", ["SelectableWindow_Doorway"])
	self.connect("object_untilted", self, "_stop_wind", ["SelectableWindow_Doorway"])
	
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


func _play_wind(identifier):
	if identifier == "SelectableWindow_Doorway":
		GlobalEvents.start_wind = true
		GlobalEvents.play_event_audio("Window")
		
		
func _stop_wind(identifier):
	if identifier == "SelectableWindow_Doorway":
		GlobalEvents.end_wind = true
