extends AnimatableBody3D

@export var ang_abertura : float = -120.0
@export var tempo : float = 1.0
@onready var som_abertura = $SomAbertura

func abrir_porta():
	if som_abertura:
		som_abertura.play()
	
	var rot_final = rotation_degrees.y + ang_abertura
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "rotation_degrees:y", rot_final, tempo)
