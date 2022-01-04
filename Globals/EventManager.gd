extends Node

signal random_change

var main_timer
var object_dict
var rng = RandomNumberGenerator.new()
var events_started

onready var alert_notifier_1 = $AlertLevel1
onready var alert_notifier_2 = $AlertLevel2
onready var kill_sound = $KillSound

var room_alert_levels

func _ready() -> void:
	events_started = false
	object_dict = {}
	room_alert_levels = {
		"Doorway": 3,
		"Kitchen": 3,
		"Storage": 3,
		"Fireplace": 3
		}
	rng.randomize()
	

func _process(_delta: float) -> void:
	_determine_room_levels()
	if GameControl.game_started and not events_started:
		events_started = true
		_start_events()
	

func _start_events():
	main_timer = Timer.new()
	add_child(main_timer)
	main_timer.autostart = true
	main_timer.wait_time = GameProgression.game_speed
	main_timer.connect("timeout", self, "main_timeout")
	main_timer.start()


func add_object(object):
	if object is FallableItem \
			or object is DecayableItem \
			or object is TiltableItem:
		
		var curr_object_name = object.get_name()
		
		var new_data_object = GlobalObjectData.new()
		new_data_object.object_name = curr_object_name
		new_data_object.alert_level = 3
		new_data_object.base_random_chance = object.base_random_chance
		new_data_object.random_chance = object.base_random_chance
		new_data_object.wall_location = object.wall_location
		new_data_object.object_alertable = true
		new_data_object.object_active = true
		new_data_object.object_position = object.get_global_position()
		new_data_object.object_min_alert_level = object.alert_level

		object_dict[curr_object_name] = new_data_object


func main_timeout():
	var curr_rand = rng.randi_range(0, 100)
	var random_event = false

	# Get current keys in random order
	var object_list = object_dict.keys()
	object_list.shuffle()

	while not random_event:
		if len(object_list) == 0:
			break
		
		var object_name = object_list.pop_at(0)
		var curr_data_object: GlobalObjectData = object_dict[object_name]
		if curr_data_object.object_alertable and curr_data_object.object_active:
			if curr_rand < curr_data_object.random_chance \
					and curr_data_object.alert_level > curr_data_object.object_min_alert_level:
				random_event = true
				_raise_alert(curr_data_object)
			else:
				curr_data_object.random_chance += 1
		else:
			pass


func _raise_alert(curr_object):
	curr_object.random_chance = curr_object.base_random_chance
	curr_object.alert_level = max(curr_object.alert_level-1, curr_object.object_min_alert_level)
	
	curr_object.object_alertable = false
	emit_signal("random_change", curr_object)
	alert_cooldown_start(curr_object)
	
	if GameControl.current_scene_name == curr_object.wall_location:
		var node_to_extract = "/root/" + curr_object.wall_location + "/GameObjects/" + curr_object.object_name
		var object_to_check = get_tree().get_root().get_node(node_to_extract)
		play_notification_level(curr_object.alert_level, curr_object.object_position)
		object_to_check.process_alert(curr_object.alert_level, curr_object.object_name)
	else:
		# We are not in the current scene - just play notification in middle of screen
		play_notification_level(curr_object.alert_level, Vector2(640, 320))


func play_notification_level(level, position_to_set):
	if level == 1:
		alert_notifier_1.position = position_to_set
		alert_notifier_1.play()
		yield(alert_notifier_1, "finished")
	elif level == 2:
		alert_notifier_2.position = position_to_set
		alert_notifier_2.play()
		yield(alert_notifier_2, "finished")
	elif level == 0:
		kill_sound.position = position_to_set
		kill_sound.play()
		yield(kill_sound, "finished")
		

func alert_cooldown_start(object):
	var alert_cooldown = Timer.new()
	add_child(alert_cooldown)
	alert_cooldown.one_shot = true
	alert_cooldown.wait_time = 10.0
	alert_cooldown.connect("timeout", self, "_alert_cooldown_timeout", [object.object_name])
	alert_cooldown.start()


func _alert_cooldown_timeout(object_name):
	object_dict[object_name].object_alertable = true


func _determine_room_levels():
	for room_name in room_alert_levels.keys():
		var curr_alert_level = 3
		for object_parameters in object_dict.values():
			if object_parameters["wall_location"] == room_name and object_parameters["alert_level"] in range(1, 3):
				curr_alert_level = min(curr_alert_level, object_parameters["alert_level"])
		room_alert_levels[room_name] = curr_alert_level
