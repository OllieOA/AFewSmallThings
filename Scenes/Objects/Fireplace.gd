extends Node2D


onready var active_sprite = $ActiveSprite
var init_frame = 2
var lose_frame = 0
var curr_frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_frame = init_frame
	active_sprite.frame = curr_frame
	GameProgression.connect("random_change", self, "random_update")
	

func random_update():
	if GameProgression.random_out > 50:
		print(GameProgression.random_out)
		curr_frame -= 1
		print(curr_frame)
		active_sprite.frame = curr_frame
