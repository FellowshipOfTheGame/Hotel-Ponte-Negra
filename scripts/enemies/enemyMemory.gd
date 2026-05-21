extends Node
class_name EnemyMemory

@export var decay_rate: float = 0.2

var last_noise_pos: Vector3 = Vector3.ZERO
var last_noise_score: float = 0.0
var last_noise_emissor: String = ""
var has_noise_to_investigate: bool = false

func _process(delta: float):
	if has_noise_to_investigate and last_noise_score > 0:
		last_noise_score -= decay_rate * delta
		
		# print("[MEMORIA] Score atual: ", last_noise_score)
		
		if last_noise_score <= 0:
			print("[MEMORIA] Esqueceu totalmente do: ", last_noise_emissor)
			last_noise_score = 0.0
			last_noise_emissor = ""

func clear_noise_memory():
	last_noise_pos = Vector3.ZERO
	last_noise_score = 0.0
	last_noise_emissor = ""
	has_noise_to_investigate = false
