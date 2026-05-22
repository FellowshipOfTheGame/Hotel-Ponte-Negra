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

func input_direction()->Vector3:
	var movX = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ = Input.get_axis("movimento_frente", "movimento_tras")
	var direction = Vector3(movX, 0, movZ)
	return direction

func dec_stamina(dec : float)->void:
	stamina = max(0, stamina - dec)
	if stamina == 0:
		tired = true
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
