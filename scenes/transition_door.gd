extends AnimatableBody3D

@export var ang_abertura : float = -120.0
@export var tempo : float = 1.0
@onready var som_abertura = $SomAbertura

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	sync_to_physics = false

func abrir_porta():
	if som_abertura:
		som_abertura.play()
	
	var rot_final = rotation_degrees.y + ang_abertura
	
	var tween : Tween = create_tween()
	
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees:y", rot_final, tempo)
