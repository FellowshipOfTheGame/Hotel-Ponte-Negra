extends State
class_name PlayerWalking

@export var velocidade : float = 10

@onready var fig: Node3D = $"../../Protagonista"
@onready var player: CharacterBody3D = $"../.."

func Enter():
	print("Entrou no walking")
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		return

func Physics_Update(_delta: float):
	if not player or not fig:
		return

	var movX : float = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ : float = Input.get_axis("movimento_frente", "movimento_tras")
	
	var direction = Vector3(movX, 0, movZ).normalized()
	
	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * velocidade
		player.velocity.z = direction.z * velocidade
		player.rotation.y = lerp_angle(player.rotation.y, atan2(-direction.x, -direction.z), _delta*5)
	else: 
		Transitioned.emit(self, "playeridle")
		return
	
	print(player.velocity.x)
	print(player.velocity.z)
	player.move_and_slide()
