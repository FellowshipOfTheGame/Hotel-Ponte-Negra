extends Area3D
class_name Vine

@export var smoke_scene: PackedScene

func _ready() -> void:
	body_entered.connect(_on_body_entered)

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
		EventBus.noise.emit(pos, 10, "vinha");
