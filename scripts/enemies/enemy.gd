extends CharacterBody3D

var player_target: Node3D = null
var can_see_player: bool = false
var fov_cos: float = cos(deg_to_rad(70))

@onready var vision_shapecast: ShapeCast3D = $ActionComponent
var attack_cooldown = 2.0
var can_attack = true

func _on_vision_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_target = body

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player_target:
		player_target = null
		can_see_player = false

func _physics_process(delta: float) -> void:
	#_update_vision_status()
	isPlayerClose()
	
	if can_attack:
		velocity = Vector3.ZERO

func _update_vision_status() -> void:
	if player_target == null:
		can_see_player = false
		return

	var direction = global_position.direction_to(player_target.global_position)
	var facing = global_transform.basis.tdotz(direction) 
	
	if facing > fov_cos:
		if _is_target_visible(player_target):
			can_see_player = true
		else:
			can_see_player = false
	else:
		can_see_player = false

func _is_target_visible(target: Node3D) -> bool:
	var space_state = get_world_3d().direct_space_state
	
	var ray_start = global_position + Vector3.UP * 1.5
	var ray_end = target.global_position + Vector3.UP * 1.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.exclude = [self] 
	
	var result = space_state.intersect_ray(query)
	
	if result and result.collider == target:
		return true
		
	return false

func isPlayerClose() -> void:
	if not vision_shapecast:
		return
	vision_shapecast.force_shapecast_update()
	if vision_shapecast.is_colliding():
		var collider = vision_shapecast.get_collider(0)
		if collider and collider.is_in_group("Player") and can_attack:
			attack(collider)
			
func attack(target):
	print("Inimigo detectou ", target.name, " com um BOXCAST e atacou!")
	if target.is_in_group("Player"):
		get_tree().reload_current_scene()
		return
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
