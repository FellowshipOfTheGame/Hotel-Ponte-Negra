extends Node3D


func _unhandled_input(event: InputEvent)->void:
	if event is InputEventKey and event.is_pressed():match event.keycode:
		KEY_ESCAPE:
			add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
			get_viewport().set_input_as_handled()
