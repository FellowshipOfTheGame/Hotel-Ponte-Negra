extends Interactable

class_name Door

@export var ang_abertura : float = 120
@export var tempo : float = 1

var aberta : bool
var rot_initial : float
var rot_final : float

func init():
	aberta = false
	rot_initial = rotation_degrees.y
	rot_final = rotation_degrees.y + ang_abertura

func open():
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if !aberta:
		tween.tween_property(self, "rotation_degrees:y", rot_final, tempo)
		aberta = true
	
	else:
		tween.tween_property(self, "rotation_degrees:y", rot_initial, tempo)
		aberta = false
		
func _ready() -> void:
	init()

func _on_interact(_interactor: Node):
	open()
