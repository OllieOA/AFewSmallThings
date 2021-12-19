extends SelectableItem

onready var particles_1 = $TiltSprite/GasFlame 
onready var particles_2 = $TiltSprite/GasFlame2

func _ready() -> void:
	my_object_name = str(self.get_name())
	wall_location = "Kitchen"
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
		if tilted and !particles_1.emitting and !particles_2.emitting:
			_toggle_particles()
		else:
			_toggle_particles()
		self.connect("object_tilted", self, "_toggle_particles")
	

func _toggle_particles():
	particles_1.emitting = !particles_1.emitting
	particles_2.emitting = !particles_2.emitting
