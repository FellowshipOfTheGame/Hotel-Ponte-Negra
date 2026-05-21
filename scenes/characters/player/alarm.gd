extends Node3D

@onready var audio_stream_player = $AudioStreamPlayer3D
@onready var radius = $AlarmArea.get_node("CollisionShape3D").shape.radius

var monsters_nearby: Array[Node3D] = []

func _process(_delta: float) -> void:
	var closest_monster_dist = get_closest_monster_pos()
	if closest_monster_dist:
		audio_stream_player.pitch_scale = lerp(2.0, 1.0, closest_monster_dist / radius)

func _on_alarm_area_body_exited(body: Node3D) -> void:
	monsters_nearby.erase(body)
	if monsters_nearby.is_empty():
		audio_stream_player.stop()

func _on_alarm_area_body_entered(body: Node3D) -> void:
	if monsters_nearby.is_empty():
		audio_stream_player.play()
	monsters_nearby.append(body)

func get_closest_monster_pos():
	if monsters_nearby.is_empty():
		return null
		
	var closest = monsters_nearby[0]
	
	var closest_distance = global_position.distance_to(
		closest.global_position
	)
	
	if monsters_nearby.size() > 1:
		for monster in monsters_nearby:
			var dist = global_position.distance_to(
				monster.global_position
			)

			if dist < closest_distance:
				closest = monster
				closest_distance = dist

	return closest_distance
