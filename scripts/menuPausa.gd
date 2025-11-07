extends Control

func _ready() -> void:
	get_tree().paused=true
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event is InputEventAction:if event.is_pressed():match event.action:
		"ui_cancel":
			get_viewport().set_input_as_handled()
			voltar()

func voltar() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	get_tree().paused=false
	queue_free()

func menuPrincipal() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/menus/menuPrincipal.tscn")

func opcoes() -> void:pass
	#add_child(preload("res://scenes/menus/menuOpcoes.tscn").instantiate())
	#$Container.visible=false


func sair() -> void:
	get_tree().quit()
