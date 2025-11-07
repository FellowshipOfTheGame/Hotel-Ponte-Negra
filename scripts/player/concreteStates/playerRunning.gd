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
	#print("Stamina:",stamina,"; ColdDown:",cold_down_run)
	if stamina == 0:
		tired = true
		
	
	player.move_and_slide()

func Exit():
	pass
	#cold_down_run = cold_down_run_max
