extends CharacterBody3D

@onready var alarm_area: Area3D = $AlarmArea

var monsters_nearby := {}
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func _on_alarm_area_body_entered(body: Node3D) -> void:
	monsters_nearby[body.get_instance_id()] = body
	print("Monster entered: ", body.name)
	update_alarm_status()

func _on_alarm_area_body_exited(body: Node3D) -> void:
	var instance_id = body.get_instance_id()
	if monsters_nearby.has(instance_id):
		monsters_nearby.erase(instance_id)
		print("Monster exited: ", body.name)
		update_alarm_status()

func update_alarm_status():
	print("Monsters nearby: ", monsters_nearby.size())
	if monsters_nearby.is_empty():
		print("No monster around!")
	else:
		print("Monsters detected!")
