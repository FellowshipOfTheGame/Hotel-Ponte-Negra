extends PlayerMoving
class_name PlayerWalking

@export_category("Walking")
@export var velocity : float = 8

func Physics_Update(delta: float):
	running = Input.is_action_pressed("correr")
	
	if !tired && running:
		Transitioned.emit(self, "playerRunning")
	
	move(velocity)
	inc_stamina(delta/2)
	print(stamina)
	if stamina == stamina_max:
		tired = false
		
	gravity_apply(delta)
	
	player.move_and_slide()
	check_for_interaction()
