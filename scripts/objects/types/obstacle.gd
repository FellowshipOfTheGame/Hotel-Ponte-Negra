extends Node3D
class_name Obstacle

func _ray_enter():
	print("Raycast colidiu com um obstáculo!")
	pass
	
func _ray_exit():
	print("Raycast paraou de colidir com um obstáculo!")
	pass
