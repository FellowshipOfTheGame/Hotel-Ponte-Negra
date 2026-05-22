extends Camera3D

@export_group("Alvo e Configurações")
@export var alvo_jogador: Node3D
@export var offset_isometrico: Vector3 = Vector3(0, 5, 3) #(0, 8, 10)
@export var suavidade: float = 5.0


var shape : ShapeCast3D
var collider
var colliders

func _ready() -> void:
	shape = $ShapeCast3D
	colliders = []

func _physics_process(delta: float) -> void:
	position_camera(delta)
	remove_obstacle(delta)
	
func position_camera(delta : float) -> void:
	if not alvo_jogador:
		return
	var posicao_desejada = alvo_jogador.global_position + offset_isometrico

	if suavidade > 0:
		global_position = global_position.lerp(posicao_desejada, delta * suavidade)
	else:
		global_position = posicao_desejada

	look_at(alvo_jogador.global_position)
	

func remove_obstacle(_delta : float) -> void:
	if not shape:
		print("Erro no shape")
		return
		
	if not alvo_jogador:
		print("Erro no jogador")
		return
		
	shape.position = position
	shape.target_position = shape.to_local(alvo_jogador.global_position + Vector3(0,0.5,0))
	
	shape.force_shapecast_update()
	
	for i in shape.get_collision_count():
		if shape.is_colliding():
			collider = shape.get_collider(i)
			#print("Colidiu com ")
			
			if collider is Obstacle:
				#print("obstacle")
				collider._shape_enter()
				
				if not collider in colliders:
					colliders.push_back(collider)

		else:
			collider = null
			
	for c in colliders:
		if c != collider:
			if(c._shape_exit()):
				colliders.erase(c)
