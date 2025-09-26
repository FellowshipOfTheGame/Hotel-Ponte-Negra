extends Node3D

@export var sensibilidade_mouse: float = 0.1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensibilidade_mouse
