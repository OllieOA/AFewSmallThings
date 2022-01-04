extends MoveButton


func _ready() -> void:	
	my_direction = "Down"
	self.connect("object_selected", self, "_move_select", [my_direction])


func _process(delta: float) -> void:
	if not GameControl.game_started and self.visible:
		self.hide()
	elif GameControl.game_started:
		self.show()
