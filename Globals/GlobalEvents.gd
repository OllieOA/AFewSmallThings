extends Node2D

# Exports for noises
export(NodePath) onready var wind_noise = get_node(wind_noise) as AudioStreamPlayer
export(NodePath) onready var wind_noise_fade = get_node(wind_noise_fade) as AnimationPlayer
export(NodePath) onready var door_noise = get_node(door_noise) as AudioStreamPlayer
export(NodePath) onready var window_noise = get_node(window_noise) as AudioStreamPlayer
export(NodePath) onready var fireplace_noise = get_node(fireplace_noise) as AudioStreamPlayer

export(NodePath) onready var negative_click = get_node(negative_click) as AudioStreamPlayer
export(NodePath) onready var positive_click = get_node(positive_click) as AudioStreamPlayer

# Bools
var start_wind : bool
var start_wind_latch : bool
var end_wind : bool
var end_wind_latch : bool


func _ready() -> void:
	start_wind = false
	start_wind_latch = false
	end_wind = false
	end_wind_latch = false
	wind_noise.volume_db = -80
	wind_noise.play()
	wind_noise.stream_paused = true
	

func _process(delta: float) -> void:
	if start_wind and not start_wind_latch:
		start_wind_latch = true
		end_wind = false
		wind_noise.stream_paused = false
		wind_noise_fade.play("FadeIn")
		yield(wind_noise_fade, "animation_finished")
		end_wind_latch = false
	elif end_wind and not end_wind_latch:
		end_wind_latch = true
		start_wind = false
		wind_noise_fade.play_backwards("FadeIn")
		wind_noise.stream_paused = true
		yield(wind_noise_fade, "animation_finished")
		start_wind_latch = false
		

func play_event_audio(object_type) -> void:
	if object_type == "Door":
		door_noise.play()
	elif object_type == "Window":
		window_noise.play()


func play_fireplace() -> void:
	fireplace_noise.play()
	
	
func play_negative_click() -> void:
	negative_click.play()
	
	
func play_positive_click() -> void:
	positive_click.play()
