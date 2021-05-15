extends Node

var audio :AudioStreamPlayer

func _ready():
	audio = AudioStreamPlayer.new()
	audio.name = "AudioStreamPlayer"
	add_child(audio)
