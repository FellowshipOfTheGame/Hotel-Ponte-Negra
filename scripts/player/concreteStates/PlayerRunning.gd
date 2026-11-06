extends PlayerMoving

class_name PlayerRunning

@export_category("Running")
@export var velocity : float = 9

func Enter():
	super.Enter()
	step_delay = 0.28
	player.is_running = true

func Physics_Update(_delta: float):
	running = Input.is_action_pressed("correr")
	crouched = Input.is_action_pressed("agachar")

	if tired || !running:
		print(tired)
		Transitioned.emit(self, "playerCrouched" if crouched else "playerWalking")
		return

	move(velocity, _delta)

func Exit():
	print("Exited Running!")
	player.is_running = false
	cold_down_run = cold_down_run_max


func Update(delta : float):
	dec_stamina(delta) #Se stamina é 0, sai do estado running e por isso não necessário nenhuma conferência
