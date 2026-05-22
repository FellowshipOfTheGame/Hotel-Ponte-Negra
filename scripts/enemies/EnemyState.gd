extends State
class_name EnemyState

signal noise_detected(noise_pos: Vector3, distance: float, intensity: float, attention_score: float)

@export var rotation_speed: float = 5.0
@export var hearing_base: float = 2.0
@export var proximity_radius: float = 2.5 

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
	if not player or not nav_agent: 
		return false
		
	if raycast:
		var target_pos = player.global_position
		target_pos.y += 1.0 
		
		raycast.target_position = raycast.to_local(target_pos)
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if not collider.is_in_group("Player"):
				return false 
				
	var map = nav_agent.get_navigation_map()
	var path = NavigationServer3D.map_get_path(map, enemy.global_position, player.global_position, true)
	
	var path_distance: float = 0.0
	for i in range(1, path.size()):
		path_distance += path[i - 1].distance_to(path[i])
		
	if path_distance > proximity_radius or path.size() == 0:
		return false
		
	return true

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
	
func process_noise(noise_pos: Vector3, base_intensity: float, source : String):
	if raycast == null:
		return
		
	var distance = enemy.global_position.distance_to(noise_pos)

	var effective_intensity = base_intensity * hearing_base
	
	if effective_intensity < distance:
		return	
		
	raycast.target_position = raycast.to_local(noise_pos)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		effective_intensity *= 0.5

	if effective_intensity < distance:
		return
		
	var attention_score = effective_intensity / max(distance, 0.1)
	
	if memory and memory.has_noise_to_investigate:
		var dist_to_old = memory.last_noise_pos.distance_to(noise_pos)
		var is_close = dist_to_old < 2.0 #Talvez mudar o raio pra ver se esta perto o bastante
		
		if is_close:
			if attention_score <= (memory.last_noise_score * 1.2):
				return 
		else:
			if attention_score <= memory.last_noise_score:
				return
	
	if memory:
		memory.last_noise_pos = noise_pos
		memory.last_noise_score = attention_score
		memory.has_noise_to_investigate = true

	#print("Inimigo ouviu o barulho na posicao: %s com score de %.2f" % [noise_pos, attention_score])
	noise_detected.emit(noise_pos, distance, base_intensity, attention_score)
