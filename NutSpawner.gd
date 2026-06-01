extends Area2D


@export var spawnArea: CollisionShape2D
@export var nutScene: PackedScene
var nuts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnNuts(16)

func SpawnNuts(amount: int):
	var size = spawnArea.shape.size / 2
	EndGame.nuts = []
	for i in amount:
		var nut = nutScene.instantiate()
		nut.global_position = Vector2(
			randf_range(-size.x, size.x),
			randf_range(-size.y, size.y)
		)
		add_child(nut)
		EndGame.AddNut(nut)
		nuts.append(nut)
