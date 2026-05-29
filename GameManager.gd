extends Node2D

@onready var basket: Area2D = $BasketArea
@onready var label: Label = $CanvasLayer/CountLabel
@onready var squirrelLabel: Label = $CanvasLayer/Panel/Label
@onready var squirrel: AnimatedSprite2D = $Squirrel
@onready var audioPlayer: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var button: Button = $CanvasLayer/Button

@export var countSounds: Array[AudioStream]  # drag in sounds 1.wav, 2.wav... in order
@export var victorySound: AudioStream
@export var nulSound: AudioStream
@export var wantSound: AudioStream
@export var nutsSound: AudioStream
@export var thanksSound: AudioStream

var count = 0
var nutsInBasket: Array[Area2D]
var wantedNuts : int
var yOffset : int = 0

func _ready() -> void:
	wantedNuts = randi_range(2, 10)
	squirrelLabel.text = "Ik wil " + str(wantedNuts) + " nootjes."
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
	if button.text == "opnieuw":
		get_tree().reload_current_scene()
		return
	button.disabled = true
	nutsInBasket = basket.get_overlapping_areas().filter(
		func(a): return a.is_in_group("nut")
	)
	start_counting()

func start_counting():
	count = 0
	$Timer.start()

# count every second
func _on_timer_timeout():
	# if the basket is empty, say 0 and show the sad squirrel
	if nutsInBasket.is_empty():
		$Timer.stop()
		audioPlayer.stream = nulSound
		audioPlayer.play()
		squirrel.play("sad")
		button.text = "opnieuw"
		button.disabled = false
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
		else:
			# verkeerd aantal noten
			squirrel.play("sad")
		
		button.text = "opnieuw"
		button.disabled = false
