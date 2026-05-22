# ControladorCameraIsometrica.gd
extends Camera3D

@export_group("Alvo e Configurações")
@export var alvo_jogador: Node3D

@export var offset_isometrico: Vector3 = Vector3(0, 5, 3) #(0, 8, 10)

@export var suavidade: float = 5.0

var rays
var collider
var colliders

func _ready() -> void:
	rays = get_children()
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
	if not rays:
		print("Erro no ray")
		return
		
	if not alvo_jogador:
		print("Erro no jogador")
		return
		
	var pos_relative : float = 0
	for r in rays:
		r.position = position + Vector3(0, -pos_relative, 0)
		r.target_position = r.to_local(alvo_jogador.global_position + Vector3(0, pos_relative,0))
		pos_relative += 0.5
	
	for r in rays:
		r.force_raycast_update()
		
		if r.is_colliding():
			collider = r.get_collider()
			#print("Colidiu com ")
			
			if collider is Obstacle:
				#print("obstacle")
				collider._ray_enter()
				
				if not (collider in colliders):
					colliders.push_back(collider)
					
			else:
				r.add_exception(collider)

		else:
			collider = null
			continue
			
		for c in colliders:
			if c != collider:
				if(c._ray_exit()):
					colliders.erase(c)
