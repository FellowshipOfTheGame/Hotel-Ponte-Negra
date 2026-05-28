extends PlayerMoving

class_name PlayerWalking

@export_category("Walking")
@export var velocity : float = 5

func Physics_Update(_delta: float):
	running = Input.is_action_pressed("correr")
	crouched = Input.is_action_pressed("agachar")

	if crouched:
		Transitioned.emit(self, "playerCrouched")

	if !tired && running && !cold_down_run:
		Transitioned.emit(self, "playerRunning")
		
	move(velocity, _delta)


func Update(delta : float): #A lógica da stamina deve estar aqui, pois o physics_process executa de tempo em tempo e não em todo frame
	if cold_down_run > 0:
		dec_coldDown(delta)
	if stamina < stamina_max:
		inc_stamina(delta/2)
