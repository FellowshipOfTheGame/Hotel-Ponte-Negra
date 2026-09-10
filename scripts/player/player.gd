extends CharacterBody3D
class_name Player

@onready var alarm_area: Area3D = $Alarm/AlarmArea
@onready var interaction_shapecast: ShapeCast3D = $"InteractionShapecast"
@onready var footstep_audio: AudioStreamPlayer3D = $FootstepPlayer
@onready var inventory: PlayerInventory = $Inventory

var stamina_bar_max : float

signal player_stamina_changed(stamina_current : float, status_tired : bool)
signal player_item_changed(item_id : String, new_amount : int)
@warning_ignore("unused_signal")
signal spacial_monster_nearby

func _ready() -> void:
	for child in $"State Machine".get_children():
		if child is PlayerState:
			stamina_bar_max = child.stamina_max
			child.stamina_changed.connect(stamina_changed_from_child)

	if inventory:
		inventory.item_changed.connect(item_changed_from_child)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	
	if is_inside_tree():
		move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity.y -= gravity * delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interacao"):
		check_for_interaction()
	
func get_stamina_max():
	return stamina_bar_max

func stamina_changed_from_child(stamina_current : float, status_tired : bool):
	print("Chegou no player.gd! Stamina: ", stamina_current) 
	player_stamina_changed.emit(stamina_current, status_tired)

func item_changed_from_child(item_id : String, new_amount : int) -> void:
	player_item_changed.emit(item_id, new_amount)
	
func check_for_interaction() -> void:
	if not interaction_shapecast:
		return

	interaction_shapecast.force_shapecast_update()

	if interaction_shapecast.is_colliding():
		var collider = interaction_shapecast.get_collider(0)
		if collider is Interactable:
			print("Player interagiu com: ", collider.name)
			collider._on_interact(self)

func set_new_key(action_name: String, new_keycode: Key):
	var event := InputEventKey.new()
	event.physical_keycode = new_keycode
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

func make_noise(intensity:float):
	EventBus.noise.emit(global_position, intensity, "Player")
	#print("Fez barulho com intensidade: " + str(intensity))

func play_footstep() -> void:
	footstep_audio.pitch_scale = randf_range(0.9, 1.1)
	footstep_audio.play()  # 
