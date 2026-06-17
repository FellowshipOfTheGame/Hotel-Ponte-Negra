extends Area3D

@export var enemy_scene: PackedScene
@export var sp: Node3D
@export var key_node: NodePath

var player_has_key := false

func _ready() -> void:
	if not key_node.is_empty():
		var key = get_node(key_node)
		if key:
			key.get_key.connect(_on_key_collected)

func _on_key_collected() -> void:
	player_has_key = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if player_has_key:
			set_deferred("monitoring", false)
			call_deferred("spawn_enemy")

func spawn_enemy() -> void:
	if enemy_scene == null:
		print("Erro: Nenhuma cena de inimigo foi selecionada no Inspetor!")
		return
		
	if sp != null:
		var novo_enemy = enemy_scene.instantiate()
		get_parent().add_child(novo_enemy)	
		novo_enemy.global_transform = sp.global_transform
				
		queue_free()
