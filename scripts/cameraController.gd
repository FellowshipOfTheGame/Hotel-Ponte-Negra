extends Node3D

@export_group("Sensibilidade")
@export var sensibilidade_mouse: float = 0.1
@export var sensibilidade_controle: float = 100.0 

@export_group("Controle")
@export var deadzone_controle: float = 0.25 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensibilidade_mouse

# Usamos _process para o controle, pois o analógico é uma entrada contínua
func _process(delta: float):
	var input_controle = Input.get_axis("olhar_esquerda", "olhar_direita")
	
	if abs(input_controle) > deadzone_controle:
		rotation_degrees.y -= input_controle * sensibilidade_controle * delta
