extends Interactable

func _on_interact(interactor: Node):
	EventBus.noise.emit(position, 300, "Sino")
	print("Emitiu som na posicao " + str(position))
	pass
	
