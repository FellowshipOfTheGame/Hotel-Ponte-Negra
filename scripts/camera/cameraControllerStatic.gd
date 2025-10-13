# ControladorCamera.gd
extends Camera3D

@export var alvo_jogador: Node3D

var objeto_obstruindo_atualmente: Obstacle = null

func _physics_process(delta: float) -> void:
	if not alvo_jogador:
		return

	var space_state = get_world_3d().direct_space_state
	var inicio_raio = self.global_position
	var fim_raio = alvo_jogador.global_position
	var query = PhysicsRayQueryParameters3D.create(inicio_raio, fim_raio)
	var resultado = space_state.intersect_ray(query)

	if resultado:
		var colisor = resultado.collider as Node
		if colisor is Obstacle:
			if colisor != objeto_obstruindo_atualmente:
				if objeto_obstruindo_atualmente:
					objeto_obstruindo_atualmente.tornar_opaco()
				colisor.tornar_transparente()
				objeto_obstruindo_atualmente = colisor
		else:
			if objeto_obstruindo_atualmente:
				objeto_obstruindo_atualmente.tornar_opaco()
				objeto_obstruindo_atualmente = null
	else:
		if objeto_obstruindo_atualmente:
			objeto_obstruindo_atualmente.tornar_opaco()
			objeto_obstruindo_atualmente = null
