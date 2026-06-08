extends Interactable

signal get_key()

@onready var SomChave = $AudioStreamPlayer3D

func _on_interact(_interactor: Node):
	print("Pegou a chave")
	SomChave.play()
	get_key.emit()
	await SomChave.finished
	queue_free()
