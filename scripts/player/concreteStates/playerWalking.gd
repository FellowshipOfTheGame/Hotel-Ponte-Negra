extends PlayerMoving
class_name PlayerWalking

@export_category("Walking")
@export var velocity : float = 8

func Physics_Update(delta: float):
	running = Input.is_action_pressed("correr")
	
	if !tired && running && !cold_down_run:
		Transitioned.emit(self, "playerRunning")
	
	move(velocity)
	dec_coldDown(delta)
	inc_stamina(delta/2)
	#print("Stamina:",stamina,"; ColdDown:",cold_down_run)
	if stamina == stamina_max:
		tired = false
	
	player.move_and_slide()
