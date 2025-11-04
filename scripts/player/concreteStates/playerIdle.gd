extends State
class_name PlayerIdle

@export var desaceleracao: float = 10.0

var player: CharacterBody3D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(_delta: float):
	if not player:
		return

	# --- 1. CHECAR TRANSIÇÃO ---
	var movX = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ = Input.get_axis("movimento_frente", "movimento_tras")
	var direction = Vector3(movX, 0, movZ)
	
	if direction != Vector3.ZERO:
		Transitioned.emit(self, "playerwalking")
		return

	# --- 2. LÓGICA DO ESTADO IDLE ---
	player.velocity.x = 0
	player.velocity.z = 0
	
	#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	#player.velocity.y -= gravity * _delta
	
	player.move_and_slide()
