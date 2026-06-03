extends Area2D

var dragging: bool = false
var offset: Vector2 = Vector2()
var my_touch_index = -1

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is InputEventScreenTouch:
		if event.pressed and my_touch_index == -1:
			dragging = true
			my_touch_index = event.index
			offset = global_position - event.position
			z_index = 10
			get_viewport().set_input_as_handled()
		elif not event.pressed and event.index == my_touch_index:
			dragging = false
			my_touch_index = -1
			z_index = 0
	
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#dragging = true
			#offset = global_position - get_global_mouse_position()
			#z_index = 10
			## drag only one nut at a time
			#get_viewport().set_input_as_handled()
		#else:
			#dragging = false
			#z_index = 0

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if event.index == my_touch_index:
			global_position = event.position + offset

#func _process(_delta: float):
	## if you are dragging, make the nut follow the mouse
	#if dragging and my_touch_index != -1:
		#var touch_pos = Input.get_touch_position(my_touch_index)
		#global_position = touch_pos + offset
