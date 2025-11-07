extends Interactable

func _on_interact(_interactor: Node):
	GameState.has_key = true
	print("You got the key.")
	queue_free()
