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
		
	#print("Stamina:",stamina,"; ColdDown:",cold_down_run)
	
	player.velocity.x = move_toward(player.velocity.x, 0, deceleration)
	player.velocity.z = move_toward(player.velocity.z, 0, deceleration)
	

func Update(delta : float):
	if stamina < stamina_max:
		inc_stamina(delta)
	if cold_down_run > 0:
		dec_coldDown(delta)
	if stamina == stamina_max:
		tired = false
