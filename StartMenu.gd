extends Node2D

@export var startSound : AudioStream
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer

func _on_start_button_pressed() -> void:
	audioPlayer.stream = startSound
	audioPlayer.play()
	await audioPlayer.finished
	get_tree().change_scene_to_file("res://Main.tscn")
