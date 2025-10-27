extends PlayerState
class_name PlayerMoving

static var running : bool

func Enter():
	init()

func move(velocity : float)->void:
	var direction : Vector3 = input_direction()
	
	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * velocity
		player.velocity.z = direction.z * velocity
		player.rotation.y = lerp_angle(player.rotation.y, atan2(-direction.x, -direction.z), velocity/100)
	else: 
		Transitioned.emit(self, "playeridle")
		return
