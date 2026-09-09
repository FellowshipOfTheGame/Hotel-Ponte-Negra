extends Interactable

signal get_key()

@onready var SomChave = $AudioStreamPlayer3D

func _on_interact(_interactor: Node):
	print("Pegou a chave")
	get_key.emit()
	EventBus.key_collected.emit()  
	hide()
	SomChave.play()
	await SomChave.finished
	queue_free()
