extends CharacterBody3D

@onready var alarm_area: Area3D = $Alarm/AlarmArea

var monsters_nearby := {}
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var awaiting_rebind := ""

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	
	if Input.is_key_pressed(KEY_CTRL):
		awaiting_rebind = "movimento_frente"
		#set_new_key("movimento_frente", KEY_Z)
	

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
		
func set_new_key(action_name: String, new_keycode: Key):
	var event := InputEventKey.new()
	event.physical_keycode = new_keycode
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

func _input(event):
	if awaiting_rebind != "" and event is InputEventKey and event.pressed and not event.echo:
		set_new_key(awaiting_rebind, event.physical_keycode)
		print(awaiting_rebind, "was rebound to ", event.as_text())
		awaiting_rebind = ""
