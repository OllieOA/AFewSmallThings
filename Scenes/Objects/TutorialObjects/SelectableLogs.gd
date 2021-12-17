extends SelectableItem

var outline_sprite_reference = preload("res://Assets/Tutorial/TutorialSceneLogsOutline.png")
var cursor_sprite_reference = preload("res://Assets/Tutorial/TutorialSceneKey.png")

var emitted

func _ready():
	outline_selection_sprite.texture = outline_sprite_reference
	cursor_sprite.texture = cursor_sprite_reference
	
	# Type definitions
	selectable = true
	extractable = true
	
