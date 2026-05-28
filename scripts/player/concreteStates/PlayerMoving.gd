extends PlayerState
class_name PlayerMoving

static var running : bool
static var crouched : bool

@export var noise_intensity: float = 5.0
var step_delay: float = 0.5
var step_timer: float = 0.0

func Enter():
	init()
	step_timer = step_delay / 2.0 

func move(velocity: float, delta: float) -> void:
	var direction : Vector3 = input_direction()

	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * velocity
		player.velocity.z = direction.z * velocity
		player.rotation.y = lerp_angle(player.rotation.y, atan2(-direction.x, -direction.z), velocity / 20) # virando o personagem
		
		if player.is_on_floor():
			step_timer -= delta
			if step_timer <= 0:
				player.make_noise(noise_intensity)
				step_timer = step_delay
				
	else:
		step_timer = 0.0
		Transitioned.emit(self, "playeridle")
		return
