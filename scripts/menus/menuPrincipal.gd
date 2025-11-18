extends Control

@export_file_path("*.tscn") var inicio:String

func jogar() -> void:
	get_tree().change_scene_to_file(inicio)

func sair() -> void:
	get_tree().quit()

func opcoes() -> void:
	add_child(preload("res://scenes/menus/menuOpcoes.tscn").instantiate())
	$Container.visible=false
