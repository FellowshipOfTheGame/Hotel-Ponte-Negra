extends Camera3D

@export_group("Alvos e Referências")
@export var alvo_jogador: Node3D

@export_group("Configurações da Câmera Orbital")
@export var distancia_da_camera: float = 8.0
@export var altura_da_camera: float = 4.0

@export_group("Sensibilidade de Rotação")
@export var sensibilidade_mouse: float = 0.005
@export var sensibilidade_controle: float = 2.0

@export_group("Controle")
@export var deadzone_controle: float = 0.25

var angulo_horizontal: float = 0.0
var objeto_obstruindo_atualmente: Obstacle = null

@export_group("Shake")
@export var shake_decay: float = 2.0
@export var shake_max_offset: float = 0.3 
@export var shake_max_rotation: float = 0.05 

var _trauma: float = 0.0
var _shake_noise := FastNoiseLite.new()
var _shake_seed: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_shake_noise.seed = randi()

func shake(amount: float) -> void:
	_trauma = clamp(_trauma + amount, 0.0, 1.0)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		angulo_horizontal -= event.relative.x * sensibilidade_mouse

func _process(delta: float):
	var input_controle = Input.get_axis("olhar_esquerda", "olhar_direita")
	if abs(input_controle) > deadzone_controle:
		angulo_horizontal -= input_controle * sensibilidade_controle * delta

func _physics_process(delta: float):
	if not alvo_jogador:
		return

	var offset = Vector3()
	offset.x = distancia_da_camera * sin(angulo_horizontal)
	offset.z = distancia_da_camera * cos(angulo_horizontal)
	offset.y = altura_da_camera

	self.global_position = alvo_jogador.global_position + offset
	self.look_at(alvo_jogador.global_position)

	if _trauma > 0.0:
		var intensidade = _trauma * _trauma
		_shake_seed += delta * 30.0

		var shake_offset = Vector3(
			_shake_noise.get_noise_2d(_shake_seed, 0.0) * shake_max_offset * intensidade,
			_shake_noise.get_noise_2d(_shake_seed, 100.0) * shake_max_offset * intensidade,
			0.0
		)
		var shake_rot = _shake_noise.get_noise_2d(_shake_seed, 200.0) * shake_max_rotation * intensidade

		self.global_position += shake_offset
		self.rotation.z += shake_rot

		_trauma = max(_trauma - shake_decay * delta, 0.0)

	var space_state = get_world_3d().direct_space_state
	var inicio_raio = self.global_position
	var fim_raio = alvo_jogador.global_position
	var query = PhysicsRayQueryParameters3D.create(inicio_raio, fim_raio)
	var resultado = space_state.intersect_ray(query)

	if resultado:
		var colisor = resultado.collider as Node
		#print("RayCast atingiu: ", colisor.name)
		if colisor is Obstacle:
			if colisor != objeto_obstruindo_atualmente:
				if objeto_obstruindo_atualmente:
					objeto_obstruindo_atualmente.tornar_opaco()
				colisor.tornar_transparente()
				objeto_obstruindo_atualmente = colisor
		else:
			if objeto_obstruindo_atualmente:
				objeto_obstruindo_atualmente.tornar_opaco()
				objeto_obstruindo_atualmente = null
	else:
		if objeto_obstruindo_atualmente:
			objeto_obstruindo_atualmente.tornar_opaco()
			objeto_obstruindo_atualmente = null
