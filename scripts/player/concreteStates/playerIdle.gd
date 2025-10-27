extends PlayerState
class_name PlayerIdle

@export var desaceleracao: float = 10.0

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
	
	gravity_apply(delta)
	
	player.move_and_slide() #para a gravidade
	
	check_for_interaction()
