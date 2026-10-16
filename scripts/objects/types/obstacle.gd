extends Node3D
class_name Obstacle

func _shape_enter() -> void:
	pass

func _shape_exit() -> void:
	pass

func _ray_enter():
	print("Raycast colidiu com um obstáculo!")
	pass
	
func _ray_exit():
	print("Raycast paraou de colidir com um obstáculo!")
	pass
