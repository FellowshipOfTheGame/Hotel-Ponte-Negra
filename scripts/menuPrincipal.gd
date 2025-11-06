extends Control

func jogar():
	get_tree().change_scene_to_file("res://scenes/base.tscn")

func sair():
	get_tree().quit()
