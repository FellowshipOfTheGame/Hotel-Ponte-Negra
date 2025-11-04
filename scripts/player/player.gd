extends CharacterBody3D

@onready var alarm_area: Area3D = $AlarmArea

var monsters_nearby := []

func _physics_process(delta: float) -> void:
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	velocity.y -= gravity * delta
	move_and_slide()

func _on_alarm_area_body_entered(body: Node3D) -> void:
	monsters_nearby.append(body)
	print(monsters_nearby)

func _on_alarm_area_body_exited(body: Node3D) -> void:
	monsters_nearby.erase(body)
	if monsters_nearby.is_empty():
		print("No monster around!")
