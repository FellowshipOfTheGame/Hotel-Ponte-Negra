extends Area3D

@export var enemy_scene: PackedScene
	
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if GameState.has_key:
			if enemy_scene != null:
				# 4. CRIA o inimigo (o "instantiate")
				var new_enemy = enemy_scene.instantiate()
				
				# 5. ADICIONA o inimigo na cena principal
				get_parent().add_child(new_enemy)
				
				# 6. POSICIONA o inimigo no lugar do trigger
				new_enemy.global_position = self.global_position
				
				# 7. DESTROI o trigger (para não spawnar mais)
				queue_free()
		else:
			print("Go get the key!")
