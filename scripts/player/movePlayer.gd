extends CharacterBody3D

@export var velocidade : float = 10
@onready var interaction_shapecast: ShapeCast3D = $ActionComponent

@onready 	var cam = $CameraPivot/Camera3D
@onready 	var fig = $MeshInstance3D

func _physics_process(delta: float) -> void:
	var movX : int = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var movZ : int = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var move : Vector3 = (movX*cam.global_basis.x + movZ*cam.global_basis.z).normalized()
	move.y = 0
	if movX || movZ:
		velocity.x = move.x * velocidade
		velocity.z = move.z * velocidade
		fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-move.x, -move.z), delta*5)
	else: #Se ele não estiver movendo, ele vai desacelerar
		velocity.x = move_toward(velocity.x, 0, velocidade*delta*2)
		velocity.z = move_toward(velocity.z, 0, velocidade*delta*2)
	move_and_slide()
