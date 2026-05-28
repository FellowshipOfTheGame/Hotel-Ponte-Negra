extends PlayerMoving

class_name PlayerRunning

@export_category("Running")
@export var velocity : float = 9

func Physics_Update(_delta: float):
	running = Input.is_action_pressed("correr")
	crouched = Input.is_action_pressed("agachar")

	if tired || !running:
		if crouched: 
			Transitioned.emit(self, "playerCrouched")
		else:
			Transitioned.emit(self, "playerWalking")

	move(velocity, _delta)


func Update(delta : float):
	dec_stamina(delta) #Se stamina é 0, sai do estado running e por isso não necessário nenhuma conferência

func Exit():
	cold_down_run = cold_down_run_max
