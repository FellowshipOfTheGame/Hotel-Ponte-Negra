extends Button

func _ready() -> void:
	var event = InputMap.action_get_events(name)[0]
	if event is InputEventJoypadMotion:
		text = event.as_text().get_slice("(",1).get_slice(",",0)
	elif event is InputEventKey:
		text = event.as_text().get_slice(" ",0)


func _input(event: InputEvent) -> void:if has_focus():
	InputMap.action_erase_events(name)
	InputMap.action_add_event(name,event)
	if event is InputEventKey:
		text = event.as_text()
		release_focus()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:if event.is_pressed():
		event.double_click = false
		text = event.as_text()
		release_focus()
		get_viewport().set_input_as_handled()
