extends Interactable

signal get_key()

@onready var SomChave = $AudioStreamPlayer3D

func _on_interact(_interactor: Node):
	print("Pegou a chave")

	if _interactor is Player:
		_interactor.inventory.add_item("chave")

	get_key.emit()
	hide()
	SomChave.play()
	await SomChave.finished
	queue_free()
