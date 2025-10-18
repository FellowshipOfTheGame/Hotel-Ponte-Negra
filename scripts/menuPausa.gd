extends Control


func _on_voltar_pressed() -> void:
	get_tree().paused=false
	self.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _on_menu_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/menus/menuPrincipal.tscn")
