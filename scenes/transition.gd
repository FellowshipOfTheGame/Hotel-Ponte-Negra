extends CanvasLayer

signal transicao_concluida

@export var tempo_camera : float = 1.5

# Atualizado os caminhos apontando para dentro do SubViewport
@onready var camera = $SubViewportContainer/SubViewport/Camera3D
@onready var porta = $SubViewportContainer/SubViewport/Porta_002

func _ready() -> void:
	camera.make_current()
	iniciar_transicao()

func iniciar_transicao():
	porta.abrir_porta()
	
	var tween_camera : Tween = create_tween()
	tween_camera.tween_interval(0.2) 
	
	# Move a câmera para frente dentro do mundo isolado dela
	var posicao_final_camera = camera.position + Vector3(0, 0, -3.0) 
	tween_camera.tween_property(camera, "position", posicao_final_camera, tempo_camera).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween_camera.tween_callback(func(): transicao_concluida.emit())
