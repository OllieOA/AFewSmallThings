extends DecayableItem


func _ready() -> void:
	killable = false
	min_alert_level = 1


func _process(_delta: float) -> void:
	if EventManager.object_dict[my_object_name].alert_level == 1:
		if not kill_sprite_animation.visible:
			kill_sprite_animation.visible = true
	else:
		if kill_sprite_animation.visible:
			kill_sprite_animation.hide()

# TODO - on object_select, add poop bag to cursor and to put in bin
