extends Node2D

@onready var squirrel : AnimatedSprite2D = $Squirrel
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer
@onready var button : Button = $CanvasLayer/Button
var playing : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !playing:
		playing = true
		audioPlayer.play()
		await audioPlayer.finished
		squirrel.play("run")
		var tween = create_tween()
		tween.tween_property(squirrel, "position", Vector2(1500, squirrel.position.y), 5.0)
		await tween.finished
		button.visible = true
		


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://StartMenu.tscn")
