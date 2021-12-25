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
	GameControl.game_started = false
	object_dict = {}
	room_alert_levels = {
		"Doorway": 3,
		"Kitchen": 3,
		"Storage": 3,
		"Fireplace": 3
		}
	rng.randomize()
	

func _process(delta: float) -> void:
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


func add_object(object, alert_level, wall_location, base_random_chance, object_decayable, object_tiltable, object_fallable, object_position):
	# Update dict
	object_dict[object] = {
		"alert_level": alert_level, 
		"base_random_chance": base_random_chance,
		"random_chance": base_random_chance, 
		"wall_location": wall_location, 
		"object_decayable": object_decayable, 
		"object_tiltable": object_tiltable, 
		"object_fallable": object_fallable,
		"object_position": object_position,
		"object_alertable": true
		}


func main_timeout():
	print(GameControl.cursor_inventory)
#	print("DEBUG: CURRENT GLOBAL DICT ", room_alert_levels)
#	print("DEBUG: CURRENT GLOBAL DICT ", object_dict)
	var curr_rand = rng.randi_range(0, 100)
	var random_event = false

	# Get current keys in random order
	var object_list = object_dict.keys()
	object_list.shuffle()

	while not random_event:
		if len(object_list) == 0:
			break
		
		var object_name_to_check = object_list.pop_at(0)
		var object_active = (
			object_dict[object_name_to_check]["object_tiltable"] or
			object_dict[object_name_to_check]["object_decayable"] or
			object_dict[object_name_to_check]["object_fallable"]
		)
		if object_dict[object_name_to_check]["object_alertable"] and object_active:
		
#			print("DEBUG: RANDOMISING CHECK WITH ", object_name_to_check)
			if curr_rand < object_dict[object_name_to_check]["random_chance"]:
#				print("DEBUG: RANDOMISING")
				object_dict[object_name_to_check]["random_chance"] = object_dict[object_name_to_check]["base_random_chance"]
				random_event = true
				if object_dict[object_name_to_check]["object_decayable"]:
					object_dict[object_name_to_check]["alert_level"] -= 1
				else:
					if object_dict[object_name_to_check]["alert_level"] == 3:
						object_dict[object_name_to_check]["alert_level"] = 2
				object_dict[object_name_to_check]["object_alertable"] = false
				emit_signal("random_change", object_name_to_check)
				if GameControl.current_scene_name == object_dict[object_name_to_check]["wall_location"]:
					# Object in current scene, access it and use the method
					var node_to_extract = "/root/" + object_dict[object_name_to_check]["wall_location"] + "/GameObjects/" + object_name_to_check
#					print("DEBUG: TRYING TO PROCESS ", node_to_extract)
					var object_to_check = get_tree().get_root().get_node(node_to_extract)
					object_to_check.process_alert(object_dict[object_name_to_check]["alert_level"], object_name_to_check)
				else:
					# We are not in the current scene
					if object_dict[object_name_to_check]["object_decayable"]:
						if object_dict[object_name_to_check]["alert_level"] == 1:
							play_notification_level(1, Vector2(640, 320))
						elif object_dict[object_name_to_check]["alert_level"] == 2:
							play_notification_level(2, Vector2(640, 320))
						elif object_dict[object_name_to_check]["alert_level"] == 0:
							play_notification_level(0, Vector2(640, 320))
						alert_cooldown_start(object_name_to_check)
			else:
#				print("DEBUG: INCREMENTING RANDOM CHANCE")
				object_dict[object_name_to_check]["random_chance"] += 1
				
		else:
#			print("DEBUG: SKIPPING, NOT ALERTABLE")
			pass
		

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
		

func alert_cooldown_start(object_name):
	var alert_cooldown = Timer.new()
#	print("DEBUG: COOLDOWN STARTED FOR ", object_name, " USING TIMER ", str(alert_cooldown))
	add_child(alert_cooldown)
	alert_cooldown.one_shot = true
	alert_cooldown.wait_time = 5.0
	alert_cooldown.connect("timeout", self, "_alert_cooldown_timeout", [object_name])
	alert_cooldown.start()


func _alert_cooldown_timeout(object_name):
#	print("DEBUG: COOLDOWN ENDED FOR ", object_name)
	object_dict[object_name]["object_alertable"] = true


func _determine_room_levels():
	for room_name in room_alert_levels.keys():
		var curr_alert_level = 3
		for object_parameters in object_dict.values():
			if object_parameters["wall_location"] == room_name and object_parameters["alert_level"] in range(1, 3):
				curr_alert_level = min(curr_alert_level, object_parameters["alert_level"])
		room_alert_levels[room_name] = curr_alert_level
