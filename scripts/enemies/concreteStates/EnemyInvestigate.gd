extends EnemyState
class_name EnemyInvestigate

var timer: float

var current_speed_mult: float = 1.0
@export var max_speed_mult: float = 1.4
@export var score_weight: float = 0.15 

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
		update_speed_multiplier(memory.last_noise_score)

func Physics_Update(_delta: float):
	if is_player_in_proximity():
		Transitioned.emit(self, "enemychasing")
		return
	investigation_routine(_delta)

func on_noise_detected(_pos: Vector3, _dist: float, _intensity: float, _score: float):
	if memory and memory.has_noise_to_investigate:
		if nav_agent:
			nav_agent.target_position = memory.last_noise_pos
			#print("[NAV] Inimigo mudou a rota para investigar: ", memory.last_noise_emissor)
		update_speed_multiplier(_score)

func update_speed_multiplier(score: float):
	var bonus_speed = score * score_weight
	current_speed_mult = clamp(1.0 + bonus_speed, 1.0, max_speed_mult)
	# print("Velocidade de investigação ajustada para: ", current_speed_mult)
	
func investigation_routine(delta: float):
	if not memory or not memory.has_noise_to_investigate:
		Transitioned.emit(self, "enemyidle")
		return

	if nav_agent.is_navigation_finished():
		enemy.velocity = Vector3.ZERO
		if timer < 4:
			#print(str(timer))
			timer += delta
		else:
			memory.clear_noise_memory()
			Transitioned.emit(self, "enemyidle")
	else:
		move_to_position(memory.last_noise_pos, 2.0, current_speed_mult, delta)
		
func Exit():
	stop_hearing()
	if noise_detected.is_connected(on_noise_detected):
		noise_detected.disconnect(on_noise_detected)
