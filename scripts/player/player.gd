extends CharacterBody3D

@onready var alarm_area: Area3D = $Alarm/AlarmArea
@onready var interaction_shapecast: ShapeCast3D = $"InteractionShapecast"

var monsters_nearby := {}
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var stamina_bar_max : float

signal player_stamina_changed(stamina_current : float) #mesmo objetivo de stamina_changed, porém reencaminha para a árvore da cena

func _ready() -> void:
	for child in $"State Machine".get_children(): #conectando o sinal que indica a mudança do valor da stamina
		if child is PlayerState:
			stamina_bar_max = child.stamina_max
			child.stamina_changed.connect(stamina_changed_from_child)

func get_stamina_max():
	return stamina_bar_max

func stamina_changed_from_child(stamina_current : float): #recaminhando sinal de mudança da stamina
	player_stamina_changed.emit(stamina_current)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
	check_for_interaction()
	
func check_for_interaction() -> void:
	if not interaction_shapecast:
		return

	if Input.is_action_just_pressed("interacao"):
		interaction_shapecast.force_shapecast_update()

		if interaction_shapecast.is_colliding():
			var collider = interaction_shapecast.get_collider(0)
			if collider is Interactable:
				print("Player interagiu com: ", collider.name)
				collider._on_interact(self)

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

#func _input(event):
	#if awaiting_rebind != "" and event is InputEventKey and event.pressed and not event.echo:
		#set_new_key(awaiting_rebind, event.physical_keycode)
		#print(awaiting_rebind, "was rebound to ", event.as_text())
		#awaiting_rebind = ""
