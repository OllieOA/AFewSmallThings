extends DecayableItem


func _ready() -> void:
	killable = false
	
	# Check for level to play flies
	_play_flies()


func _process(_delta: float) -> void:
	_play_flies()


func _play_flies():
	if EventManager.object_dict[my_object_name].alert_level == 1:
		if not kill_sprite_animation.visible:
			kill_sprite_animation.show()
		if not kill_sprite_animation.playing:
			kill_sprite_animation.play()
	else:
		if kill_sprite_animation.visible:
			kill_sprite_animation.hide()

# TODO - on object_select, add poop bag to cursor and to put in bin
