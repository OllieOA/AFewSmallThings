extends SelectableItem

var outline_sprite_reference = preload("res://Assets/Tutorial/TutorialSceneRock1Outline.png")
var placemat_sprite_reference = preload("res://Assets/Tutorial/TutorialSceneRock1Placemat.png")
var cursor_sprite_reference = preload("res://Assets/Tutorial/TutorialSceneRock1Cursor.png")

func _ready():
	outline_selection_sprite.texture = outline_sprite_reference
	placemat_sprite.texture = placemat_sprite_reference
	cursor_sprite.texture = cursor_sprite_reference
	
	# Object type setup
	selectable = true
	pickable = true
	picked = false
	dropable = true
	extractable = false
