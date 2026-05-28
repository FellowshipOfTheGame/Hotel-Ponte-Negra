extends PlayerMoving

class_name PlayerCrouched

@export_category("Crouched")
@export var velocity : float = 1.0

func Enter():
	super.Enter()
	print("Entrou em agachado")

func Physics_Update(_delta: float):
	running = Input.is_action_pressed("correr")
	crouched = Input.is_action_pressed("agachar")

	if !crouched: 
		if !tired && running && !cold_down_run:
			Transitioned.emit(self, "playerRunning")
		else:
			Transitioned.emit(self, "playerWalking")
	move(velocity, _delta)


func Update(delta : float):
	if cold_down_run > 0:
		dec_coldDown(delta)
	if stamina < stamina_max:
		inc_stamina(delta/2)
