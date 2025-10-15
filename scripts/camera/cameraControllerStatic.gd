# ControladorCameraIsometrica.gd
extends Camera3D

@export_group("Alvo e Configurações")
@export var alvo_jogador: Node3D

@export var offset_isometrico: Vector3 = Vector3(0, 8, 10)


@export var suavidade: float = 5.0

@export_group("Detecção de Obstáculos")
var objeto_obstruindo_atualmente: Node = null

func _physics_process(delta: float) -> void:
	if not alvo_jogador:
		return
	var posicao_desejada = alvo_jogador.global_position + offset_isometrico

	if suavidade > 0:
		global_position = global_position.lerp(posicao_desejada, delta * suavidade)
	else:
		global_position = posicao_desejada

	look_at(alvo_jogador.global_position)


	var space_state = get_world_3d().direct_space_state
	var inicio_raio = self.global_position
	var fim_raio = alvo_jogador.global_position + Vector3.UP * 1.0 
	
	var query = PhysicsRayQueryParameters3D.create(inicio_raio, fim_raio)
	query.exclude = [alvo_jogador]
	
	var resultado = space_state.intersect_ray(query)

	if resultado:
		var colisor = resultado.collider
		if colisor.has_method("tornar_transparente"):
			if colisor != objeto_obstruindo_atualmente:
				limpar_obstaculo_anterior() 
				
				colisor.tornar_transparente()
				objeto_obstruindo_atualmente = colisor
		else:
			limpar_obstaculo_anterior()
	else:
		limpar_obstaculo_anterior()
		
func limpar_obstaculo_anterior():
	if is_instance_valid(objeto_obstruindo_atualmente) and objeto_obstruindo_atualmente.has_method("tornar_opaco"):
		objeto_obstruindo_atualmente.tornar_opaco()
	objeto_obstruindo_atualmente = null
