extends Node3D


func _on_start() -> void:
	add_child(preload("res://scenes/characters/player/player.tscn").instantiate())
	$MenuPrincipal.free()
