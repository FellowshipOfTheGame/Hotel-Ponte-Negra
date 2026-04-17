extends EnemyState
class_name EnemyInvestigate

var timer: float

func Enter():
	super.Enter() 
	print("Entrou em investigar")
	start_hearing()
	
	if not noise_detected.is_connected(on_noise_detected):
		noise_detected.connect(on_noise_detected)
		
	timer = 0.0 
	
	if memory and memory.has_noise_to_investigate:
		if nav_agent:
			nav_agent.target_position = memory.last_noise_pos

func Physics_Update(_delta: float):
	investigation_routine(_delta)

func on_noise_detected(pos: Vector3, dist: float, intensity: float, score: float):
	if memory and memory.has_noise_to_investigate:
		if nav_agent:
			nav_agent.target_position = memory.last_noise_pos
	timer = 0.0

func investigation_routine(delta: float):
	if not memory or not memory.has_noise_to_investigate:
		Transitioned.emit(self, "enemyidle")
		return

	if nav_agent.is_navigation_finished():
		if timer < 4:
			timer += delta
		else:
			memory.clear_noise_memory()
			Transitioned.emit(self, "enemyidle")
	else:
		move_to_position(memory.last_noise_pos, 2.0, 1.0, delta)
		
func Exit():
	stop_hearing()
	if noise_detected.is_connected(on_noise_detected):
		noise_detected.disconnect(on_noise_detected)
