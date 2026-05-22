extends EnemyState
class_name EnemyChasing

@export var speed: float = 6.0
@export var lose_interest_time: float = 3.0 
var time_without_stimulus: float = 0.0

func Enter():
	super.Enter() 
	time_without_stimulus = 0.0
	print("Sentiu o jogador! Entrou em chasing")
	
	if not noise_detected.is_connected(on_noise_detected):
		noise_detected.connect(on_noise_detected)

func Physics_Update(delta: float):
	if not player or not memory:
		return

	if is_player_in_proximity():
		time_without_stimulus = 0.0 
		memory.last_noise_pos = player.global_position 
		memory.has_noise_to_investigate = true
	else:
		time_without_stimulus += delta

	move_to_position(memory.last_noise_pos, speed, 1.0, delta)

	if time_without_stimulus >= lose_interest_time:
		print("Perdeu o rastro! Voltando a investigar...")
		Transitioned.emit(self, "enemyinvestigate")

func on_noise_detected(pos: Vector3, dist: float, intensity: float, score: float):
	time_without_stimulus = 0.0
	if memory:
		memory.last_noise_pos = pos

func Exit():
	if noise_detected.is_connected(on_noise_detected):
		noise_detected.disconnect(on_noise_detected)
