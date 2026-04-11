extends PlayerMoving

class_name PlayerWalking

@export_category("Walking")
@export var velocity : float = 5

func Physics_Update(_delta: float):
	running = Input.is_action_pressed("correr")

	if !tired && running && !cold_down_run:
		Transitioned.emit(self, "playerRunning")

	move(velocity)
	#print("Stamina:",stamina,"; ColdDown:",cold_down_run)

	#player.move_and_slide() #Já está no script principal do player

func Update(delta : float): #A lógica da stamina deve estar aqui, pois o physics_process executa de tempo em tempo e não em todo frame
	if cold_down_run > 0:
		dec_coldDown(delta)
	if stamina < stamina_max:
		inc_stamina(delta/2)
