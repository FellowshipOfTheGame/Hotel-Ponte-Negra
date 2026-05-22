extends CharacterBody3D

## Configurações de Combate
@export var attack_cooldown: float = 2.0
var can_attack: bool = true

@onready var action_cast: ShapeCast3D = $ActionComponent

func _physics_process(delta: float) -> void:
	
	apply_gravity(delta)
	if can_attack:
		check_attack_collision()
	
	if is_inside_tree(): # Evita erros no restart
		move_and_slide()

func check_attack_collision() -> void:
	action_cast.force_shapecast_update()
	
	if action_cast.is_colliding():
		for i in action_cast.get_collision_count():
			var collider = action_cast.get_collider(i)
			if collider.is_in_group("Player"):
				execute_attack()
				collider.get_node("State Machine").current_state.die()
				
				break

func execute_attack() -> void:
	can_attack = false
	#print("Inimigo atacou o alvo detectado!")
	
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity.y -= gravity * delta
