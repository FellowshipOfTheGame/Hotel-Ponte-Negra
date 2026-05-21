extends Interactable

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var aberta : bool = false

func _on_interact(_interactor: Node):
	animation.play("abrir_porta")
	aberta = !aberta
