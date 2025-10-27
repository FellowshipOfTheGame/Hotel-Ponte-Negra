extends PlayerMoving
class_name PlayerRunning

@export_category("Running")
@export var velocity : float = 15

func Physics_Update(delta: float):
	running = Input.is_action_pressed("correr")
	
	if tired || !running:
		Transitioned.emit(self, "playerWalking")
	
	move(velocity)
	dec_stamina(delta)
	print(stamina)
	if stamina == 0:
		tired = true
		
	gravity_apply(delta)
	
	player.move_and_slide()
	check_for_interaction()
