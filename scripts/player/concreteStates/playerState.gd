extends State
class_name PlayerState

const stamina_max :float = 5
static var stamina : float = stamina_max
static var tired : bool

var player : CharacterBody3D
var fig : MeshInstance3D
var interaction_shapecast : ShapeCast3D

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
	stamina = max(0, stamina - dec)
	
func inc_stamina(inc : float)->void:
	stamina = min(stamina + inc, stamina_max)
	
func check_for_interaction() -> void:
	if not player or not interaction_shapecast:
		return

	if Input.is_action_just_pressed("interacao"):
		interaction_shapecast.force_shapecast_update()

		if interaction_shapecast.is_colliding():
			var collider = interaction_shapecast.get_collider(0)
			if collider is Interactable:
				print("Player interagiu com: ", collider.name)
				collider._on_interact(player)

func gravity_apply(delta : float):
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	player.velocity.y -= gravity * delta
