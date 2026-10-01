extends State

class_name PlayerState

const stamina_max : float = 3
const cold_down_run_max : float = 0 #Por enquanto está sem cold-dowwn
static var stamina : float = stamina_max
static var tired : bool
static var cold_down_run : float

var player : CharacterBody3D
var fig : Node3D
var interaction_shapecast : ShapeCast3D

signal stamina_changed(stamina_current:float, status_tired:bool)

func init():
	player = get_parent().get_parent()
	fig = player.get_node_or_null("Protagonista")
	interaction_shapecast = player.get_node_or_null("InteractionShapecast")
	if !player || !fig || !interaction_shapecast:
		print("Error in getting Character or Mesh")

# Direção do input em espaço de mundo, relativa à câmera ativa
func input_direction() -> Vector3:
	var input := Input.get_vector(
		"movimento_esquerda", "movimento_direita",
		"movimento_frente", "movimento_tras"
	)
	if input == Vector2.ZERO:
		return Vector3.ZERO

	var direction := Vector3(input.x, 0, input.y)

	var camera := get_viewport().get_camera_3d()
	if camera:
		direction = direction.rotated(Vector3.UP, camera.global_rotation.y)

	return direction

func dec_stamina(dec : float)->void:
	stamina = max(0, stamina - dec)
	if stamina == 0:
		tired = true
	print("dec_stamina chamado, emitindo: ", stamina) 
	stamina_changed.emit(stamina, tired)

func inc_stamina(inc : float)->void:
	stamina = min(stamina + inc, stamina_max)
	if stamina == stamina_max:
		tired = false
	stamina_changed.emit(stamina, tired)

func dec_coldDown(dec : float):
	cold_down_run = max(cold_down_run - dec, 0)
	
func die():
	Transitioned.emit(self, "playerDead")
	
func stun():
	Transitioned.emit(self, "playerStunned")
