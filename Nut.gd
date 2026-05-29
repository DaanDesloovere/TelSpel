extends Area2D

var dragging: bool = false
var offset: Vector2 = Vector2()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = global_position - get_global_mouse_position()
			z_index = 10
			# drag only one nut at a time
			get_viewport().set_input_as_handled()
		else:
			dragging = false
			z_index = 0

func _process(_delta: float):
	# if you are dragging, make the nut follow the mouse
	if dragging:
		global_position = get_global_mouse_position() + offset
