extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if GameState.has_key:
			print("Au-au!")
		else:
			print("Go get the key!")
