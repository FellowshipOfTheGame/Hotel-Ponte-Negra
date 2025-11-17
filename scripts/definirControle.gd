extends Button
@export var acao:String

func _ready() -> void:
	if InputMap.has_action(acao):
		text=InputMap.action_get_events(acao)[0].as_text().trim_suffix(" (Physical)")
	if!text:text="nao definido"


func _input(event: InputEvent) -> void:
	if event is InputEventKey:if has_focus():
		text=OS.get_keycode_string(event.keycode)
		release_focus()
		get_viewport().set_input_as_handled()
