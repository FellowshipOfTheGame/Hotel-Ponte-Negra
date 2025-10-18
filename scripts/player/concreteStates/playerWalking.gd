extends State
class_name PlayerWalking

@export var velocidade : float = 10

var interaction_shapecast: ShapeCast3D
var fig: MeshInstance3D
var player : CharacterBody3D

func Enter():
	print("Entrou no walking")
	player = get_tree().get_first_node_in_group("Player")
	if not player:
		return

	fig = player.get_node_or_null("Protagonista")
	interaction_shapecast = player.get_node_or_null("ActionComponent")

func Physics_Update(_delta: float):
	if not player or not fig:
		return

	var movX : float = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ : float = Input.get_axis("movimento_frente", "movimento_tras")
	
	var direction = Vector3(movX, 0, movZ).normalized()
	
	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * velocidade
		player.velocity.z = direction.z * velocidade
		fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-direction.x, -direction.z), _delta*5)
	else: 
		Transitioned.emit(self, "playeridle")
		return
	
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	player.velocity.y -= gravity * _delta
	
	player.move_and_slide()
	check_for_interaction()

func check_for_interaction() -> void:
	if not player or not interaction_shapecast:
		return

	if Input.is_action_just_pressed("interacao"):
		interaction_shapecast.force_shapecast_update()

		if interaction_shapecast.is_colliding():
			var collider = interaction_shapecast.get_collider(0)
			if collider is Interactable:
				print("Player interagiu com: ", collider.name)
				collider._on_interact(player)
