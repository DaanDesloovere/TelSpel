extends Node2D

@onready var basket: Area2D = $BasketArea
@onready var label: Label = $CanvasLayer/CountLabel
@onready var squirrelLabel: Label = $CanvasLayer/Panel/Label
@onready var squirrel: AnimatedSprite2D = $Squirrel
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var button: Button = $CanvasLayer/Button
@onready var retryButton : Button = $CanvasLayer/RetryButton
@onready var nextButton : Button = $CanvasLayer/NextButton
@onready var nutArea : Area2D = $NutSpawnArea
@onready var nutAreaCollision : CollisionShape2D = $NutSpawnArea/NutSpawnShape
@onready var nextTimer : Timer = $NextTimer

@export var countSounds: Array[AudioStream]  # drag in sounds 1.wav, 2.wav... in order
@export var victorySound: AudioStream
@export var nulSound: AudioStream
@export var wantSound: AudioStream
@export var nutsSound: AudioStream
@export var thanksSound: AudioStream
@export var tryAgainSound: AudioStream
@export var startSound: AudioStream

var count = 0
var nutsInBasket: Array[Area2D]
var wantedNuts : int
var yOffset : int = 0

func _ready() -> void:
	wantedNuts = randi_range(2, 10)
	squirrelLabel.text = "Ik wil " + str(wantedNuts) + " eikels."
	playIntro()

# play the intro sound saying how many nuts the squirrel wants.
func playIntro() -> void:
	audioPlayer.stream = wantSound
	audioPlayer.play()
	await audioPlayer.finished
	audioPlayer.stream = countSounds[wantedNuts-1]
	audioPlayer.play()
	await audioPlayer.finished
	audioPlayer.stream = nutsSound
	audioPlayer.play()

# either count the nuts or reset the game
func _on_button_pressed() -> void:
	button.disabled = true
	nutsInBasket = basket.get_overlapping_areas().filter(
		func(a): return a.is_in_group("nut")
	)
	start_counting()

func start_counting():
	count = 0
	yOffset = 0
	$Timer.start()

# count every second
func _on_timer_timeout():
	# if the basket is empty, say 0 and show the sad squirrel
	if nutsInBasket.is_empty():
		$Timer.stop()
		audioPlayer.stream = nulSound
		audioPlayer.play()
		await audioPlayer.finished
		audioPlayer.stream = tryAgainSound
		audioPlayer.play()
		squirrel.play("sad")
		button.visible = false
		retryButton.visible = true
		return

	# line up the nuts
	var nut = nutsInBasket[count]
	nut.global_position = Vector2((count%8) * 80 + 350, 125 + yOffset)
	
	# new line for lineup
	if (count == 7):
		yOffset	= 80
	
	# play the counting audio
	audioPlayer.stream = countSounds[count]
	audioPlayer.play()
	
	count += 1
	label.visible = true
	label.text = str(count)
	
	# if you counted all the nuts in the basket
	# stop the timer, play the song and dance when it is correct
	# otherwise show the squirrel as sad
	if count >= nutsInBasket.size():
		$Timer.stop()
		# wacht tot de laatste sound klaar is, dan victory
		await audioPlayer.finished
		if count == wantedNuts:
			squirrelLabel.text = "Dankjewel!"
			audioPlayer.stream = thanksSound
			audioPlayer.play()
			await audioPlayer.finished
			squirrel.play("dance")
			audioPlayer.stream = victorySound
			audioPlayer.play()
			nextButton.visible = true
			nextTimer.start()
		else:
			# verkeerd aantal noten
			audioPlayer.stream = tryAgainSound
			audioPlayer.play()
			squirrel.play("sad")
			await audioPlayer.finished
			retryButton.visible = true
		
		button.visible = false


func _on_retry_button_pressed() -> void:
	playIntro()
	squirrel.play("idle")
	label.text = ""
	retryButton.visible = false
	button.visible = true
	button.disabled = false
	for nut in EndGame.nuts:
		var size = nutAreaCollision.shape.size / 2
		nut.global_position = nutArea.global_position + Vector2(
			randf_range(-size.x, size.x),
			randf_range(-size.y, size.y)
		)
	
func _on_next_button_pressed() -> void:
	var reload = EndGame.AddOne()
	if reload:
		get_tree().change_scene_to_file("res://EndGame.tscn")
	else:
		get_tree().reload_current_scene()


func _on_next_timer_timeout() -> void:
	_on_next_button_pressed()
