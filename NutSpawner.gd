extends Area2D


@export var spawnArea: CollisionShape2D
@export var nutScene: PackedScene
var nuts = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnNuts(16)

func SpawnNuts(amount: int):
	var size = spawnArea.shape.size / 2
	
	#var nut1 = nutScene.instantiate()
	#nut1.global_position = Vector2(-size.x, -size.y)
	#var nut2 = nutScene.instantiate()
	#nut2.global_position = Vector2(-size.x, size.y)
	#var nut3 = nutScene.instantiate()
	#nut3.global_position = Vector2(size.x, -size.y)
	#var nut4 = nutScene.instantiate()
	#nut4.global_position = Vector2(size.x, size.y)
	#add_child(nut1)
	#add_child(nut2)
	#add_child(nut3)
	#add_child(nut4)
	for i in amount:
		var nut = nutScene.instantiate()
		nut.global_position = Vector2(
			randf_range(-size.x, size.x),
			randf_range(-size.y, size.y)
		)
		add_child(nut)
		nuts.append(nut)
