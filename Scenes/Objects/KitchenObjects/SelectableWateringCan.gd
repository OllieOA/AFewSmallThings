extends SelectableItem

func _ready():
	wall_location = "Kitchen"
	
	# Object type setup
	selectable = true
	pickable = true
	picked = false
	dropable = false
	
	if GameControl.cursor_inventory == str(self.get_name()):
		picked = true
		dropable = true
		base_sprite.hide()
		outline_alert_sprite.hide()
		placemat_sprite.show()


func _process(delta: float) -> void:
	if GameControl.current_scene_name != wall_location:
		dropable = false
	else:
		dropable = true
