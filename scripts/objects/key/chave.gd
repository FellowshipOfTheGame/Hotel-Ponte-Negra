extends Interactable

signal get_key()

@onready var SomChave = $AudioStreamPlayer3D

func _on_interact(_interactor: Node):
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()
	print("Pegou a chave")
	get_key.emit()
	
	SomChave.play()
	await SomChave.finished
	queue_free()
