extends Interactable
class_name Root

@export var required_item: String = "herbicida"
@export var required_amount: int = 1
@export var consume_item: bool = true

@export var puzzle_group: String = ""

@onready var vine_sound: AudioStreamPlayer3D = (
	$AudioStreamPlayer3D if has_node("AudioStreamPlayer3D") else null
)

func _ready() -> void:
	if puzzle_group != "":
		add_to_group(puzzle_group)

func _on_interact(_interactor: Node):
	if puzzle_group == "":
		push_warning("Vine sem puzzle_group definido em: " + str(get_path()))
		return

	var has_required := false
	if _interactor is Player:
		has_required = _interactor.inventory.has_item(required_item, required_amount)

	if not has_required:
		print("Precisa de ", required_item, " para eliminar esse caule.")
		return

	if consume_item and _interactor is Player:
		_interactor.inventory.remove_item(required_item, required_amount)

	print("Caule eliminado!")
	remove_from_group(puzzle_group)
	hide()

	if get_tree().get_nodes_in_group(puzzle_group).is_empty():
		EventBus.puzzle_solved.emit(puzzle_group)

	if vine_sound:
		vine_sound.play()
		await vine_sound.finished

	queue_free()
