extends PlayerState
class_name PlayerIdle

@export var deceleration: float = 5

func Enter():
	init()

func Physics_Update(delta: float):
	var direction : Vector3 = input_direction()
	
	if direction != Vector3.ZERO:
		Transitioned.emit(self, "playerwalking")
		return
	
	inc_stamina(delta)
	print(stamina)
	if stamina == stamina_max:
		tired = false
	
	player.velocity.x = move_toward(player.velocity.x, 0, deceleration)
	player.velocity.z = move_toward(player.velocity.z, 0, deceleration)
	
	gravity_apply(delta)
	
	player.move_and_slide() #para a gravidade
	
	check_for_interaction()
