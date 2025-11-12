extends CharacterBody3D

@export var velocidade:float = 10
@export var vel_ang:float = 2
var rad:float = 0

func modulo(rad:float)->float:
	if rad > 2*PI:
		return rad - 2*PI
	elif rad < 0:
		return rad + 2*PI
	return rad

func _physics_process(delta: float) -> void:
	var movA:int = int(Input.is_action_pressed("mover_esquerda")) - int(Input.is_action_pressed("mover_direita"))
	rad += movA * delta * vel_ang
	rad = modulo(rad)
	if movA:
		rotation.y = lerp_angle(rotation.y, rad, delta*5)
	var move_input:float = float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up"))
	var move:Vector3
	if move_input != 0:
		move = Vector3(sin(rad)*move_input, 0, cos(rad)*move_input).normalized()*velocidade
		if move_input > 0:
			move *= 0.3 
		move.y = 0
		velocity.x = move.x
		velocity.z = move.z
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade*delta*3)
		velocity.z = move_toward(velocity.z, 0, velocidade*delta*3)
	move_and_slide()
