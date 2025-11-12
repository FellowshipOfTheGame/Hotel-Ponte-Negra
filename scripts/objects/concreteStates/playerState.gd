extends State
class_name PlayerState

const stamina_max : float = 5
const cold_down_run_max : float = 1.5
static var stamina : float = stamina_max
static var tired : bool
static var cold_down_run : float

var player : CharacterBody3D
var fig : MeshInstance3D
var interaction_shapecast : ShapeCast3D

signal changes_stamina

func init():
	player = get_tree().get_first_node_in_group("Player")
	fig = player.get_node_or_null("Protagonista")
	interaction_shapecast = player.get_node_or_null("ActionComponent")
	if !player || !fig || !interaction_shapecast:
		print("Error in getting Character or Mesh")

func input_direction()->Vector3:
	var movX = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ = Input.get_axis("movimento_frente", "movimento_tras")
	var direction = Vector3(movX, 0, movZ)
	return direction

func dec_stamina(dec : float)->void:
	pass
	#if stamina == 0: return
	#changes_stamina.emit()
	#stamina = max(0, stamina - dec)
	
func inc_stamina(inc : float)->void:
	pass
	#if stamina == stamina_max: return
	#changes_stamina.emit()
	#stamina = min(stamina + inc, stamina_max)
	
func dec_coldDown(dec : float):
	pass
	#cold_down_run = max(cold_down_run - dec, 0)
