extends Node3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
		get_viewport().set_input_as_handled()
