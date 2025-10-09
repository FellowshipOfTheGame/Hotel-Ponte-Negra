extends CharacterBody3D

@export var speed: float = 5.0

var player: Node3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null:
		print_debug("Inimigo não conseguiu encontrar o nó do jogador. Verifique o grupo 'Player'.")
		return 

	var direcao = global_position.direction_to(player.global_position)
	
	velocity = velocity.lerp(direcao * speed, delta * 2.0)
	
	look_at(player.global_position, Vector3.UP)
	
	move_and_slide()
