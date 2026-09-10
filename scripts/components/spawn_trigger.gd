extends Node3D
@export var enemy_scene: PackedScene
@export var sp: Node3D
@onready var windowBreaking = $WindowBreaking

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.player_item_changed.connect(on_player_item_changed)

func on_player_item_changed(item_id: String, new_amount: int) -> void:
	if item_id != "chave" or new_amount <= 0:
		return

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
