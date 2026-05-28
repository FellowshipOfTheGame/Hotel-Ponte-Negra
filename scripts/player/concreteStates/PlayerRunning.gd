extends PlayerMoving

class_name PlayerRunning

@export_category("Running")
@export var velocity : float = 9

func Physics_Update(_delta: float):
	running = Input.is_action_pressed("correr")

	if tired || !running:
		Transitioned.emit(self, "playerWalking")

	move(velocity, _delta)

	#print("Stamina:",stamina,"; ColdDown:",cold_down_run)
	#player.move_and_slide() #Já está no script principal do player

func Update(delta : float):
	dec_stamina(delta) #Se stamina é 0, sai do estado running e por isso não necessário nenhuma conferência

func Exit():
	cold_down_run = cold_down_run_max
