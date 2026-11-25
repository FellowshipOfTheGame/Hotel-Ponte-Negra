extends Area3D
class_name Vine

@export var smoke_scene: PackedScene
@export var puzzle_group: String = ""

@export_group("Ressecar")
@export var leaf_mesh: MeshInstance3D
@export var leaf_surface: int = 1
@export var dry_duration: float = 5.0
@export var free_after_dry: bool = false

var _dried := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	EventBus.puzzle_solved.connect(_on_puzzle_solved)

func _on_puzzle_solved(solved_group: String) -> void:
	if solved_group != puzzle_group or _dried:
		return
	_dried = true
	set_deferred("monitoring", false)
	_dry_leaves()

func _dry_leaves() -> void:
	if leaf_mesh == null:
		return

	var mat := leaf_mesh.get_surface_override_material(leaf_surface) as ShaderMaterial
	if mat == null:
		return

	mat = mat.duplicate() as ShaderMaterial
	leaf_mesh.set_surface_override_material(leaf_surface, mat)

	var tween := create_tween()
	tween.tween_property(mat, "shader_parameter/dry_amount", 1.0, dry_duration)

	if free_after_dry:
		var target := get_parent() if get_parent() else self
		tween.tween_callback(target.queue_free)

func _on_body_entered(body: Node3D) -> void:
	if body is not Player:
		return

	var state_machine: StateMachine = body.get_node("State Machine")
	var current = state_machine.current_state

	if current is PlayerStunned or current.name.to_lower() == "playerdead":
		return

	if current is PlayerState:
		_spawn_smoke(body.global_position)
		current.stun()

func _spawn_smoke(pos: Vector3) -> void:
	if smoke_scene == null:
		return
	var smoke: Node3D = smoke_scene.instantiate()
	get_tree().current_scene.add_child(smoke)
	smoke.global_position = pos

	var sfx: AudioStreamPlayer3D = smoke.get_node_or_null("AudioStreamPlayer3D")
	if sfx:
		sfx.play()
		EventBus.noise.emit(pos, 10, "vinha")
