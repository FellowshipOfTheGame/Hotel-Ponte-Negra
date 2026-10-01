extends Camera3D

@export_group("Alvos e Referências")
@export var alvo_jogador: Node3D
@export var altura_do_foco: float = 1.0

@export_group("Órbita")
@export var distancia_da_camera: float = 8.0
@export_range(10.0, 80.0) var inclinacao_graus: float = 30.0

@export_group("Suavização")
@export var suavidade_rotacao: float = 10.0
@export var suavidade_posicao: float = 12.0

@export_group("Sensibilidade")
@export var sensibilidade_mouse: float = 0.003
@export var sensibilidade_controle: float = 2.5

var _angulo_alvo: float = 0.0
var _angulo_atual: float = 0.0
var _foco_suave: Vector3


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if alvo_jogador:
		_foco_suave = _ponto_de_foco()
		_aplicar_transform()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_angulo_alvo -= event.relative.x * sensibilidade_mouse
	elif event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta: float) -> void:
	if not alvo_jogador:
		return

	# Deadzone configurada na própria ação do Input Map
	var input_controle := Input.get_axis("olhar_esquerda", "olhar_direita")
	_angulo_alvo -= input_controle * sensibilidade_controle * delta
	_angulo_alvo = wrapf(_angulo_alvo, -PI, PI)

	var t_rot := 1.0 - exp(-suavidade_rotacao * delta)
	var t_pos := 1.0 - exp(-suavidade_posicao * delta)
	_angulo_atual = wrapf(lerp_angle(_angulo_atual, _angulo_alvo, t_rot), -PI, PI)
	_foco_suave = _foco_suave.lerp(_ponto_de_foco(), t_pos)

	_aplicar_transform()


func get_yaw() -> float:
	return _angulo_atual


func _ponto_de_foco() -> Vector3:
	return alvo_jogador.global_position + Vector3.UP * altura_do_foco


func _aplicar_transform() -> void:
	var inclinacao := deg_to_rad(inclinacao_graus)
	var horizontal := distancia_da_camera * cos(inclinacao)
	var offset := Vector3(
		horizontal * sin(_angulo_atual),
		distancia_da_camera * sin(inclinacao),
		horizontal * cos(_angulo_atual)
	)
	global_position = _foco_suave + offset
	look_at(_foco_suave, Vector3.UP)
