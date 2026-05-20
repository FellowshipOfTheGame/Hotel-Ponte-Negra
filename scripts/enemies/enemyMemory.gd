extends Node
class_name EnemyMemory

@export var decay_rate: float = 10.0

var last_noise_pos: Vector3 = Vector3.ZERO
var last_noise_score: float = 0.0
var has_noise_to_investigate: bool = false

func _process(delta: float):
	if has_noise_to_investigate and last_noise_score > 0:
		last_noise_score -= decay_rate * delta
		if last_noise_score < 0:
			last_noise_score = 0.0

func clear_noise_memory():
	last_noise_pos = Vector3.ZERO
	last_noise_score = 0.0
	has_noise_to_investigate = false
