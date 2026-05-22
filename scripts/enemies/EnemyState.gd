extends State
class_name EnemyState

signal noise_detected(noise_pos: Vector3, distance: float, intensity: float, attention_score: float)

@export var rotation_speed: float = 5.0
@export var hearing_base: float = 2.0
@export var proximity_radius: float = 5

var enemy: CharacterBody3D
var player: Node3D
var nav_agent: NavigationAgent3D
var raycast: RayCast3D
var memory: EnemyMemory

func Enter():
	enemy = owner as CharacterBody3D
	player = get_tree().get_first_node_in_group("Player")
	
	if enemy:
		nav_agent = enemy.get_node_or_null("NavigationAgent3D")
		raycast = enemy.get_node_or_null("RayCast3D")
		memory = enemy.get_node_or_null("EnemyMemory")
		
		if raycast == null:
			print("ERRO: RayCast3D não encontrado")
		if memory == null:
			print("ERRO: EnemyMemory não encontrado")

func is_player_in_proximity() -> bool:
	if not player: 
		return false
		
	# 1. Checagem de distância plana (como já fazíamos)
	var enemy_pos_flat = enemy.global_position
	var player_pos_flat = player.global_position
	enemy_pos_flat.y = 0
	player_pos_flat.y = 0
	
	if enemy_pos_flat.distance_to(player_pos_flat) > proximity_radius:
		return false # Está muito longe
		
	# 2. Checagem de Parede (Line of Sight)
	if raycast:
		# Aponta o raio para a posição do jogador
		# Somamos +1.0 no Y para mirar no peito do jogador e o raio não raspar no chão
		var target_pos = player.global_position
		target_pos.y += 1.0 
		
		raycast.target_position = raycast.to_local(target_pos)
		raycast.force_raycast_update()
		
		# Se o raio bateu em alguma coisa...
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			# Se bateu numa parede, porta, caixa (qualquer coisa que NÃO seja o Player)
			if not collider.is_in_group("Player"):
				return false # O inimigo "vê" a parede, então finge que o player não está ali

	return true # Está perto E tem linha de visão livre!

func move_to_position(target_position: Vector3, base_speed: float, speed_mult: float, delta: float):
	if not enemy or not nav_agent:
		return
		
	var next_path_pos := nav_agent.get_next_path_position()
	var direction := enemy.global_position.direction_to(next_path_pos)
	direction.y = 0 
	
	if direction.length() < 0.01:
		enemy.velocity = Vector3.ZERO 
		enemy.move_and_slide()
		return

	direction = direction.normalized()
	var final_speed = base_speed * speed_mult	
	enemy.velocity = direction * final_speed
	
	var target_rotation := atan2(direction.x, direction.z)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, delta * rotation_speed)
	
	enemy.move_and_slide()

func start_hearing():
	if not EventBus.noise.is_connected(process_noise):
		EventBus.noise.connect(process_noise)
	
func stop_hearing():
	if EventBus.noise.is_connected(process_noise):
		EventBus.noise.disconnect(process_noise)
	
func process_noise(noise_pos: Vector3, base_intensity: float, emissor: String = ""):
	if raycast == null: return
		
	var distance = enemy.global_position.distance_to(noise_pos)
	var effective_intensity = base_intensity * hearing_base
	
	if effective_intensity < distance: return	
		
	raycast.target_position = raycast.to_local(noise_pos)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		effective_intensity *= 0.5

	if effective_intensity < distance: return
		
	var attention_score = effective_intensity / max(distance, 0.1)
	
	if emissor == "Player" and distance <= 5.0:
		attention_score *= 5.0 


	#print("\n[AUDIO IN] Emissor: ", emissor, " | Score Calculado: ", step_decimals(attention_score), " | Memória Atual: ", step_decimals(memory.last_noise_score), " (", memory.last_noise_emissor, ")")

	if memory and memory.has_noise_to_investigate:
		if memory.last_noise_emissor == "Player" and emissor != "Player":
			if attention_score <= (memory.last_noise_score * 3.0):
				#print("   -> BLOQUEADO: Gramofone não teve força pra roubar a atenção do Player.")
				return
			else:
				pass
				#print("   -> ALERTA: Gramofone furou o escudo! Score muito alto!")

		var dist_to_old = memory.last_noise_pos.distance_to(noise_pos)
		var is_close = dist_to_old < 2.0
		
		if is_close:
			if attention_score <= (memory.last_noise_score * 1.2):
				#print("   -> BLOQUEADO: Som muito perto do antigo, não é maior que 20%.")
				return 
		else:
			if attention_score <= (memory.last_noise_score * 1.3):
				#print("   -> BLOQUEADO: Som distante, não é maior que 30%.")
				return
	
	if memory:
		memory.last_noise_pos = noise_pos
		memory.last_noise_score = attention_score
		memory.last_noise_emissor = emissor 
		memory.has_noise_to_investigate = true
		#print("   -> SUCESSO: Memória sobrescrita pelo: ", emissor)

	noise_detected.emit(noise_pos, distance, base_intensity, attention_score)
