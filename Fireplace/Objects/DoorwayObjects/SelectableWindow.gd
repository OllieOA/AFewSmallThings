extends SelectableItem

func _ready() -> void:
	tiltable = true
	self.connect("object_tilted", self, "_play_wind", ["SelectableWindow_Doorway"])
	self.connect("object_untilted", self, "_stop_wind", ["SelectableWindow_Doorway"])


func _play_wind(identifier):
	if identifier == "SelectableWindow_Doorway":
		GlobalEvents.start_wind = true
		
		
func _stop_wind(identifier):
	if identifier == "SelectableWindow_Doorway":
		GlobalEvents.end_wind = true
