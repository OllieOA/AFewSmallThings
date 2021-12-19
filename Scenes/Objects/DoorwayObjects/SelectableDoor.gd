extends SelectableItem

func _ready() -> void:
	my_object_name = self.get_name()
	tiltable = true
	self.connect("object_tilted", self, "_play_wind", ["SelectableDoor_Doorway"])
	self.connect("object_untilted", self, "_stop_wind", ["SelectableDoor_Doorway"])


func _play_wind(identifier):
	if identifier == "SelectableDoor_Doorway":
		GlobalEvents.start_wind = true
		
		
func _stop_wind(identifier):
	if identifier == "SelectableDoor_Doorway":
		GlobalEvents.end_wind = true
