extends Control


func _on_jogar_pressed() -> void:
	get_tree().paused=false
	self.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _on_sair_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/menus/menuPrincipal.tscn")
