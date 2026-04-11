extends State
class_name  EnemyState

@export var rotation_speed: float = 5.0

var enemy: CharacterBody3D
var player: Node3D
var nav_agent: NavigationAgent3D

var hearing_base: float = 2.0
var raycast: RayCast3D

func Enter():
	enemy = owner as CharacterBody3D
	player = get_tree().get_first_node_in_group("Player")
	
	if enemy:
		nav_agent = enemy.get_node_or_null("NavigationAgent3D")
		raycast = enemy.get_node_or_null("RayCast3D")
		
		if raycast == null:
			print("ERRO: RayCast3D não encontrado como filho de ", enemy.name)
		
	if not enemy or not player or not nav_agent:
		push_warning("EnemyState (%s): Falha ao encontrar dependências." % name)
	
#Função geral para navegação com navmesh
func move_to_position(target_position: Vector3, speed: float, delta: float):
	if not enemy or not nav_agent:
		return
		
	nav_agent.target_position = target_position
	var next_path_pos := nav_agent.get_next_path_position()
	
	var direction := enemy.global_position.direction_to(next_path_pos)
	direction.y = 0 
	
	if direction.length() < 0.01:
		enemy.velocity = Vector3.ZERO 
		enemy.move_and_slide()
		return

	direction = direction.normalized()
	enemy.velocity = direction * speed
	
	var target_rotation := direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, delta * rotation_speed)
	
	enemy.move_and_slide()

#Funcoes do sistema de detecção
func start_hearing():
	EventBus.noise.connect(process_noise)
	
func process_noise(noise_pos: Vector3, intensity: float):
	if raycast == null:
		return
	var distance = enemy.global_position.distance_to(noise_pos)
	var noise_intensity = intensity * hearing_base
	if noise_intensity < distance:
		return	
		
	raycast.target_position = raycast.to_local(noise_pos)
	raycast.force_raycast_update()
	print("Distancia: " + str(distance) + " Intensidade: " + str(noise_intensity))
	
	if raycast.is_colliding():
		noise_intensity *= 0.5 
		print("Intensidade reduzida por causa de obstaculo")
	
	if noise_intensity >= distance:
		print("Inimigo ouviu o barulho na posicao: " + str(noise_pos))
	
	
		
