extends EnemyState
class_name EnemyIdle

func Enter():
	super.Enter()
	start_hearing()
	if not noise_detected.is_connected(on_noise_detected):
		noise_detected.connect(on_noise_detected)
	print("Entrou em idle")

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func on_noise_detected(pos: Vector3, dist: float, intensity: float, score: float):
	Transitioned.emit(self, "enemyinvestigate")

func Exit():
	stop_hearing()
	if noise_detected.is_connected(on_noise_detected):
		noise_detected.disconnect(on_noise_detected)
