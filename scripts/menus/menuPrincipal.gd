extends Control

@export var inicio:PackedScene

func jogar() -> void:
	get_tree().change_scene_to_file(inicio.resource_path)

func sair() -> void:
	get_tree().quit()

func opcoes() -> void:
	add_child(preload("res://scenes/menus/menuOpcoes.tscn").instantiate())
	$Container.visible=false
