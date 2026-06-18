extends Node3D
@export var enemy_scene: PackedScene
@export var sp: Node3D
@onready var windowBreaking = $WindowBreaking

func _ready() -> void:
	EventBus.key_collected.connect(on_key_collected)

func on_key_collected() -> void:
	await get_tree().create_timer(0.5).timeout
	if windowBreaking:
		windowBreaking.play()
	spawn_enemy() 
	if windowBreaking:
		await windowBreaking.finished 
	queue_free()

func spawn_enemy() -> void:
	if enemy_scene == null:
		return
	var novo_enemy = enemy_scene.instantiate()
	get_parent().add_child(novo_enemy)
	novo_enemy.global_transform = sp.global_transform
