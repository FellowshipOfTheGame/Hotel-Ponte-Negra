extends Interactable

signal get_veneno()

@onready var SomVeneno = $AudioStreamPlayer3D

func _on_interact(_interactor: Node):
	print("Pegou o veneno")

	if _interactor is Player:
		_interactor.inventory.add_item("veneno")

	get_veneno.emit()
	hide()
	SomVeneno.play()
	await SomVeneno.finished
	queue_free()
