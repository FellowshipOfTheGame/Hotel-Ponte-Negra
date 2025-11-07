extends State
class_name ChasingState

@export var speed: float = 5.0
@export var rotation_speed: float = 5.0 

var nav_agent: NavigationAgent3D = null

var player: Node3D = null
var enemy: CharacterBody3D

func Enter():
	enemy = owner as CharacterBody3D
	player = get_tree().get_first_node_in_group("Player")
	nav_agent = enemy.get_node_or_null("NavigationAgent3D")
	if not enemy or not player:
		push_warning("Estado Chasing falhou ao encontrar Inimigo, Player ou NavAgent.")
		return
	
func Physics_Update(_delta: float):
	if player == null or nav_agent == null or enemy == null:
		return
	nav_agent.target_position = player.global_position
	
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
