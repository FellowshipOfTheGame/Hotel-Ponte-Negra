extends Interactable

signal get_key()

func _on_interact(_interactor: Node):
	print("Pegou a chave")
	get_key.emit()
	queue_free()
