extends Interactable

var open : bool

func _ready() -> void:
	open = false

func _on_interact(_interactor: Node):
	if _interactor.name == "Player":
		if GameState.chave:
			open = true
			print("Aberta")
		else:
			print("Trancada")
