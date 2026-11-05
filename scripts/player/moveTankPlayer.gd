extends Node
class_name MoveTankPlayer

@export var velocidade: float = 10.0
@export var multiplicador_corrida: float = 1.5
@export var vel_ang: float = 2.0

var rad: float = 0.0

func process_movement(body: CharacterBody3D, delta: float, can_run: bool) -> bool:
	# Se o corpo estiver morto, zera a velocidade horizontal
	if "is_dead" in body and body.is_dead:
		body.velocity.x = 0
		body.velocity.z = 0
		return false

	# Rotação (Tank)
	var movA: int = int(Input.is_action_pressed("olhar_esquerda")) - int(Input.is_action_pressed("olhar_direita"))
	rad += movA * delta * vel_ang
	rad = modulo(rad)
	if movA != 0:
		body.rotation.y = lerp_angle(body.rotation.y, rad, delta * 5)
	
	# Movimento frente/trás
	var move_input: float = float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	var quer_correr: bool = Input.is_action_pressed("correr") and move_input != 0 and can_run
	var vel_atual: float = velocidade * (multiplicador_corrida if quer_correr else 1.0)

	var move: Vector3
	if move_input != 0:
		move = Vector3(sin(rad) * move_input, 0, cos(rad) * move_input).normalized() * vel_atual
		if move_input > 0:
			move *= 0.3 
		move.y = 0
		body.velocity.x = move.x
		body.velocity.z = move.z
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, velocidade * delta * 3)
		body.velocity.z = move_toward(body.velocity.z, 0, velocidade * delta * 3)

	return quer_correr

func modulo(value: float) -> float:
	if value > 2 * PI:
		return value - 2 * PI
	elif value < 0:
		return value + 2 * PI
	return value