extends MeshInstance3D

@export var camera: Camera3D 

@export var y_offset: float = 1.0 

func _input(event: InputEvent):
	if not camera:
		return
		
	if event.is_action_pressed("ui_text_caret_word_left") or Input.is_physical_key_pressed(KEY_1):
		EventBus.noise.emit(global_position, 2.0)
		print("TESTE: Barulho BAIXO gerado em ", global_position)
		
	if event.is_action_pressed("ui_text_caret_word_right") or Input.is_physical_key_pressed(KEY_2):
		EventBus.noise.emit(global_position, 10.0)
		print("TESTE: Barulho ALTO gerado em ", global_position)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_target = ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0
		
		var space_state = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
		
		var result = space_state.intersect_ray(ray_query)
	
		if result:
			if result.normal.y > 0.8:
				
				var final_position = result.position
				final_position.y += y_offset
				
				global_position = final_position
				print("TESTE: Movido para ", global_position)
			else:
				print("TESTE: Clique ignorado (Parede ou teto bloqueado)")
