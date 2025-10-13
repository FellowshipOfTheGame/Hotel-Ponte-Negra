extends Camera3D

@export var alvo: Node3D
@export var offset: Vector3 = Vector3(0, 10, 8)
@export_range(0.0, 1.0) var suavizacao: float = 0.95


func _physics_process(delta: float):
	if not is_instance_valid(alvo):
		return
	var posicao_ideal = alvo.global_position + offset
	global_position = global_position.lerp(posicao_ideal, 1.0 - suavizacao)
	look_at(alvo.global_position, Vector3.UP)
