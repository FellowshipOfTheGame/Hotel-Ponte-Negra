extends Interactable

@export var ang_abertura : float = 120
@export var tempo : float = 1

@onready var aberta : bool = false
@onready var rot_inicial : float = rotation_degrees.y
@onready var rot_final : float = rotation_degrees.y + ang_abertura

func _on_interact(_interactor: Node):
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if !aberta:
		tween.tween_property(self, "rotation_degrees:y", rot_final, tempo)
		aberta = true
	
	else:
		tween.tween_property(self, "rotation_degrees:y", rot_inicial, tempo)
		aberta = false
