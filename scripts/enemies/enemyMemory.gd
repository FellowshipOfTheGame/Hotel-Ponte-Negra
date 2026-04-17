extends Node
class_name EnemyMemory

var last_noise_pos: Vector3 = Vector3.ZERO
var last_noise_score: float = 0.0
var has_noise_to_investigate: bool = false

func clear_noise_memory():
	last_noise_pos = Vector3.ZERO
	last_noise_score = 0.0
	has_noise_to_investigate = false
