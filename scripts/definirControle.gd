extends Button
@export var acao:String

func _ready() -> void:
	if!InputMap.has_action(acao):text="nao definido";return
	var event = InputMap.action_get_events(acao)[0]
	if event is InputEventJoypadMotion:
		text = event.as_text().get_slice("(",1).get_slice(",",0)
	elif event is InputEventKey:
		text = event.as_text().get_slice(" ",0)


func _input(event: InputEvent) -> void: if has_focus():
	if!InputMap.has_action(acao):return
	InputMap.action_erase_events(acao)
	InputMap.action_add_event(acao,event)
	if event is InputEventKey:
		text = event.as_text()
		release_focus()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:if event.is_pressed():
		event.double_click = false
		text = event.as_text()
		release_focus()
		get_viewport().set_input_as_handled()
