extends Node3D

const pausa:PackedScene=preload("res://scenes/menus/menuPausa.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().root.add_child(pausa.instantiate())
		get_viewport().set_input_as_handled()
