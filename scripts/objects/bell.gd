extends Interactable

func _on_interact(_interactor: Node):
	EventBus.noise.emit(position, 600, "Sino")
	print("Emitiu som na posicao " + str(position))
	pass
	
