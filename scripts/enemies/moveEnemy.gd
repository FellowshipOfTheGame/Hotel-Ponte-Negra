extends CharacterBody3D

@export var speed: float = 5.0
@onready var vision_shapecast: ShapeCast3D = $ActionComponent

var player: Node3D = null

var attack_cooldown = 2.0
var can_attack = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null:
		print_debug("Inimigo não conseguiu encontrar o nó do jogador. Verifique o grupo 'Player'.")
		return 

	isPlayerClose()
	if can_attack == true:
		var direcao = global_position.direction_to(player.global_position)
		velocity = velocity.lerp(direcao * speed, delta * 2.0)
		look_at(player.global_position, Vector3.UP)
		move_and_slide()
	
func isPlayerClose() -> void:
	if vision_shapecast.is_colliding():
		var collider = vision_shapecast.get_collider(0)
		if collider and collider.is_in_group("Player") and can_attack:
			attack(collider)
			
func attack(target):
	print("Inimigo detectou ", target.name, " com um BOXCAST e atacou!")
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
