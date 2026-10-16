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

@export_group("Oclusão")
@export var ocluir_obstaculos: bool = true

@export_flags_3d_physics var mascara_obstaculos: int = 1
@export var raio_deteccao: float = 0.3

var _angulo_alvo: float = 0.0
var _angulo_atual: float = 0.0
var _foco_suave: Vector3

var _shape: ShapeCast3D
var _obstaculos_atuais: Array[Obstacle] = []


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_criar_shapecast()

	if alvo_jogador:
		_foco_suave = _ponto_de_foco()
		_aplicar_transform()


func _criar_shapecast() -> void:
	_shape = get_node_or_null("ShapeCast3D") as ShapeCast3D
	if _shape == null:
		_shape = ShapeCast3D.new()
		_shape.name = "ShapeCast3D"
		add_child(_shape)

	var esfera := SphereShape3D.new()
	esfera.radius = raio_deteccao
	_shape.shape = esfera
	_shape.collision_mask = mascara_obstaculos
	_shape.max_results = 32
	_shape.enabled = false 

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

	var input_controle := Input.get_axis("olhar_esquerda", "olhar_direita")
	_angulo_alvo -= input_controle * sensibilidade_controle * delta
	_angulo_alvo = wrapf(_angulo_alvo, -PI, PI)

	var t_rot := 1.0 - exp(-suavidade_rotacao * delta)
	var t_pos := 1.0 - exp(-suavidade_posicao * delta)
	_angulo_atual = wrapf(lerp_angle(_angulo_atual, _angulo_alvo, t_rot), -PI, PI)
	_foco_suave = _foco_suave.lerp(_ponto_de_foco(), t_pos)

	_aplicar_transform()

	if ocluir_obstaculos:
		_atualizar_oclusao()


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


func _atualizar_oclusao() -> void:
	if _shape == null:
		return
		
	_shape.position = Vector3.ZERO
	_shape.target_position = _shape.to_local(_ponto_de_foco())
	_shape.force_shapecast_update()

	var atuais: Array[Obstacle] = []
	for i in _shape.get_collision_count():
		var obstaculo := _achar_obstaculo(_shape.get_collider(i))
		if obstaculo and not obstaculo in atuais:
			atuais.append(obstaculo)

	for o in atuais:
		if not o in _obstaculos_atuais:
			o._shape_enter()

	for o in _obstaculos_atuais:
		if is_instance_valid(o) and not o in atuais:
			o._shape_exit()

	_obstaculos_atuais = atuais


func _achar_obstaculo(no: Node) -> Obstacle:
	while no:
		if no is Obstacle:
			return no
		no = no.get_parent()
	return null
