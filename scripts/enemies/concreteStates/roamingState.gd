extends State
class_name RoamingState

@export var speed: float = 2.0
@export var rotation_speed: float = 4.0 

@export var roam_radius: float = 6.0 

var nav_agent: NavigationAgent3D = null
var enemy: CharacterBody3D
var start_position: Vector3 

func Enter():
	enemy = owner as CharacterBody3D
	nav_agent = enemy.get_node_or_null("NavigationAgent3D")
	if not enemy or not nav_agent:
		push_warning("Estado Roaming falhou ao encontrar Inimigo ou NavAgent.")
		return
	start_position = enemy.global_position
	_pick_new_roaming_point()

func Exit():
	if nav_agent:
		nav_agent.target_position = enemy.global_position
		enemy.velocity = Vector3.ZERO
	

# Chamado a cada quadro de física
func Physics_Update(_delta: float):
	if enemy == null or nav_agent == null:
		return
	
	if enemy.can_see_player:
		Transitioned.emit(self, "chasingState")
		return 
	
	if nav_agent.is_navigation_finished():
		_pick_new_roaming_point()
		enemy.velocity = Vector3.ZERO 
		enemy.move_and_slide()
		return 

	var next_path_pos := nav_agent.get_next_path_position()
	var direction := enemy.global_position.direction_to(next_path_pos)
	
	if direction.length() < 0.01:
		enemy.velocity = Vector3.ZERO
		enemy.move_and_slide()
		return

	direction = direction.normalized()
	enemy.velocity = direction * speed
	
	var target_rotation := direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, _delta * rotation_speed)
	
	enemy.move_and_slide()

func _pick_new_roaming_point():
	var random_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	var random_distance = randf_range(0, roam_radius)
	var target_point_in_world = start_position + random_direction * random_distance

	var map_rid = enemy.get_world_3d().navigation_map
	var valid_nav_point = NavigationServer3D.map_get_closest_point(map_rid, target_point_in_world)

	nav_agent.target_position = valid_nav_point
