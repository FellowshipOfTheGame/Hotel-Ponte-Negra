extends Interactable

func _on_interact(_interactor: Node):
	GameState.add_item("key")
	print("You got the key.")
	queue_free()
