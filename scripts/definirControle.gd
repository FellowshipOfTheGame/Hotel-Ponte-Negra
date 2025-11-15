extends Button


func _input(event: InputEvent) -> void:
	if event is InputEventKey:if has_focus():
		text=OS.get_keycode_string(event.keycode)
		release_focus()
		get_viewport().set_input_as_handled()
