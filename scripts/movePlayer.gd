extends CharacterBody3D

@export var velocidade : float = 10
@onready var interaction_shapecast: ShapeCast3D = $ActionComponent

func _process(delta : float)->void:
	var movX : float = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ : float = Input.get_axis("movimento_frente", "movimento_tras")
	
	var movimento = Vector3(movX, 0, movZ).normalized() * (velocidade * delta) #vetor indica a nova posição e por isso é multiplicado por algo de dimensão de comprimento 
	position += movimento
	check_for_interaction()

func check_for_interaction() -> void:
	if Input.is_action_just_pressed("interacao"):

		interaction_shapecast.force_shapecast_update()

		if interaction_shapecast.is_colliding():
			var collider = interaction_shapecast.get_collider(0)
			if collider is Interactable:
				print("Player interagiu com: ", collider.name)
				collider._on_interact(self)
