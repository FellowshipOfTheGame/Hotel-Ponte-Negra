extends Interactable

func _on_interact(_interactor: Node):
	if _interactor.name == "Player": 
		GameState.chave = true
		queue_free()
