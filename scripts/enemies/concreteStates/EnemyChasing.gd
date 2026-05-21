extends EnemyState
class_name EnemyChasing

@export var speed: float = 6.0
@export var lose_interest_time: float = 3.0 
@export var attack_range: float = 1.8 

var time_without_stimulus: float = 0.0

func Enter():
	super.Enter() 
	time_without_stimulus = 0.0
	print("Entrou em chasing")

func Physics_Update(delta: float):
	if not player:
		return

	var enemy_pos_flat = enemy.global_position
	var player_pos_flat = player.global_position
	enemy_pos_flat.y = 0
	player_pos_flat.y = 0
	
	var dist_to_player = enemy_pos_flat.distance_to(player_pos_flat)

	if nav_agent:
		nav_agent.target_position = player.global_position
		
	if dist_to_player <= 10.0:
		time_without_stimulus = 0.0 
	else:
		time_without_stimulus += delta

	if time_without_stimulus >= lose_interest_time:
		#print("Perdeu o rastro! Voltando a investigar...")
		if memory:
			memory.last_noise_pos = player.global_position 
			memory.has_noise_to_investigate = true
		Transitioned.emit(self, "enemyinvestigate")
		return

	
	if dist_to_player > attack_range:
		var next_path_pos := nav_agent.get_next_path_position()
		var direction := enemy.global_position.direction_to(next_path_pos)
		direction.y = 0 
		
		if direction.length() > 0.01:
			direction = direction.normalized()
			enemy.velocity = direction * speed
			
			var target_rotation := atan2(direction.x, direction.z)
			enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, delta * 8.0)
	else:
		enemy.velocity = Vector3.ZERO
		
		var look_dir := enemy.global_position.direction_to(player.global_position)
		look_dir.y = 0
		if look_dir.length() > 0.01:
			var target_rotation := atan2(look_dir.x, look_dir.z)
			enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, delta * 12.0) # Vira rápido para bater

	enemy.move_and_slide()
