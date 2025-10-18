extends CharacterBody3D

@export var velocidade : float = 10
@onready var interaction_shapecast: ShapeCast3D = $ActionComponent
@onready var fig: MeshInstance3D = $Protagonista

func _physics_process(delta: float) -> void:
	var movX : float = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ : float = Input.get_axis("movimento_frente", "movimento_tras")
	
	var direction = Vector3(movX, 0, movZ).normalized()
	
	if movX || movZ:
		velocity.x = direction.x * velocidade
		velocity.z = direction.z * velocidade
		fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-direction.x, -direction.z), delta*5)
	else: #Se ele não estiver movendo, ele vai desacelerar
		velocity.x = move_toward(velocity.x, 0, velocidade*delta*2)
		velocity.z = move_toward(velocity.z, 0, velocidade*delta*2)
	
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	velocity.y -= gravity * delta
	
	move_and_slide()
	check_for_interaction()

func check_for_interaction() -> void:
	if Input.is_action_just_pressed("interacao"):

		interaction_shapecast.force_shapecast_update()

		if interaction_shapecast.is_colliding():
			var collider = interaction_shapecast.get_collider(0)
			if collider is Interactable:
				print("Player interagiu com: ", collider.name)
				collider._on_interact(self)
