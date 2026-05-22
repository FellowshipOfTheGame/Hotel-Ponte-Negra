extends Interactable

func _on_interact(_interactor: Node):
	EventBus.noise.emit(position, 500, "Sino")
	print("Emitiu som na posicao " + str(position))
	pass
	
