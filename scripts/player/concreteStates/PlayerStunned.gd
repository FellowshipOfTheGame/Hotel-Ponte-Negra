extends PlayerMoving
class_name PlayerStunned

@export_category("Stunned")
@export var velocity : float = 1.0
@export var stun_duration : float = 3.0

func Enter():
	super.Enter()
	step_delay = 0.65
	dec_stamina(stamina_max)
	#print("Stamina após stun: ", stamina) 
	var camera := get_viewport().get_camera_3d()
	if camera and camera.has_method("shake"):
		camera.shake(0.6)
	await get_tree().create_timer(stun_duration).timeout
	if is_instance_valid(player):
		Transitioned.emit(self, "playeridle")

func Physics_Update(_delta: float):
	move(velocity, _delta)

func move(velocity: float, delta: float) -> void:
	var direction : Vector3 = input_direction()

	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * velocity
		player.velocity.z = direction.z * velocity
		player.rotation.y = lerp_angle(player.rotation.y, atan2(-direction.x, -direction.z), velocity / 20)

		if player.is_on_floor():
			step_timer -= delta
			if step_timer <= 0:
				player.make_noise(noise_intensity)
				player.play_footstep()
				step_timer = step_delay
	else:
		step_timer = 0.0
		player.velocity.x = move_toward(player.velocity.x, 0, velocity)
		player.velocity.z = move_toward(player.velocity.z, 0, velocity)

#func Exit():
	#print("Saiu do stun")
