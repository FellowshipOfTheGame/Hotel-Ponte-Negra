extends Node3D

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused=true
		$MenuPausa.visible=true
