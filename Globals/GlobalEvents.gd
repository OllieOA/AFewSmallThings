extends Node2D

onready var wind_audio = $Wind
onready var wind_audio_fade = $Wind/AudioFade

onready var door_noise = $DoorNoise
onready var window_noise = $WindowNoise
onready var fire_noise = $FireplaceAmbient

var start_wind
var start_wind_latch
var end_wind
var end_wind_latch


func _ready() -> void:
	start_wind = false
	start_wind_latch = false
	end_wind = false
	end_wind_latch = false
	wind_audio.volume_db = -80
	wind_audio.play()
	wind_audio.stream_paused = true
	

func _process(delta: float) -> void:
	if start_wind and not start_wind_latch:
		start_wind_latch = true
		end_wind = false
		wind_audio.stream_paused = false
		wind_audio_fade.play("FadeIn")
		yield(wind_audio_fade, "animation_finished")
		end_wind_latch = false
	elif end_wind and not end_wind_latch:
		end_wind_latch = true
		start_wind = false
		wind_audio_fade.play_backwards("FadeIn")
		wind_audio.stream_paused = true
		yield(wind_audio_fade, "animation_finished")
		start_wind_latch = false
		

func play_event_audio(object_type):
	if object_type == "Door":
		door_noise.play()
	elif object_type == "Window":
		window_noise.play()
		

func play_fireplace():
	fire_noise.play()
		
