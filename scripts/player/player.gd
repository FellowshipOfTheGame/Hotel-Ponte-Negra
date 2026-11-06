extends CharacterBody3D
class_name Player

@export_category("Stamina")
@export var stamina_max: float = 100.0
@export var consumo_stamina: float = 20.0
@export var regeneracao_stamina: float = 15.0

@export_category("Animations")
@export var anim_idle : String = "Idle/mixamo_com"
@export var anim_walk : String = "Walking/mixamo_com"
@export var anim_run : String = "Run Forward/mixamo_com"
@export var anim_crouch : String = "Crounch/mixamo_com"
@export var anim_stunned : String = ""
@export var anim_die : String = "Death/mixamo_com"
@export var anim_blend_time : float = 0.2

@onready var tank_movement: MoveTankPlayer = get_node_or_null("MoveTankPlayer")
@onready var interaction_shapecast: ShapeCast3D = $"InteractionShapecast"
@onready var footstep_audio: AudioStreamPlayer3D = $FootstepPlayer
@onready var inventory: PlayerInventory = $Inventory

var stamina_bar_max: float
var stamina_atual: float
var is_dead: bool = false
var is_running: bool = false
var is_tired: bool = false

signal player_stamina_changed(stamina_current : float, status_tired : bool)
signal player_item_changed(item_id : String, new_amount : int)
@warning_ignore("unused_signal")
signal spacial_monster_nearby

func _ready() -> void:
	stamina_bar_max = stamina_max
	stamina_atual = stamina_max
	
	# Garante que a HUD receba o valor inicial
	player_stamina_changed.emit(stamina_atual, is_tired)

	if inventory:
		inventory.item_changed.connect(item_changed_from_child)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	apply_gravity(delta)
	
	if tank_movement:
		var can_run: bool = stamina_atual > 0 and not is_tired
		is_running = tank_movement.process_movement(self, delta, can_run)
	
	process_stamina(delta)
	update_animations()
	
	if is_inside_tree():
		move_and_slide()

func process_stamina(delta: float) -> void:
	var stamina_anterior: float = stamina_atual

	if is_running and Vector2(velocity.x, velocity.z).length() > 0.1:
		stamina_atual -= consumo_stamina * delta
		if stamina_atual <= 0:
			stamina_atual = 0
			is_tired = true
			is_running = false
	else:
		if stamina_atual < stamina_max:
			stamina_atual += regeneracao_stamina * delta
			if stamina_atual >= stamina_max:
				stamina_atual = stamina_max
				is_tired = false

	print("Stamina Atual: " + str(stamina_atual) + " Is tired: " + str(is_tired))
	
	if stamina_atual != stamina_anterior:
		player_stamina_changed.emit(stamina_atual, is_tired)

func update_animations() -> void:
	if is_dead:
		return

	var is_moving : bool = Vector2(velocity.x, velocity.z).length() > 0.1

	if is_moving:
		if is_running:
			play_animation(anim_run)
		else:
			play_animation(anim_walk)
	else:
		play_animation(anim_idle)

func morrer() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector3.ZERO
	
	var animation_player : AnimationPlayer = get_node_or_null("AnimationPlayer")
	if animation_player:
		animation_player.stop()
		if animation_player.has_animation(anim_die):
			animation_player.play(anim_die)
			await animation_player.animation_finished

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity.y -= gravity * delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interacao"):
		check_for_interaction()

func get_stamina_max() -> float:
	return stamina_max

func stamina_changed_from_child(stamina_current : float, status_tired : bool) -> void:
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
			collider._on_interact(self)

func set_new_key(action_name: String, new_keycode: Key) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = new_keycode
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

func make_noise(intensity: float) -> void:
	EventBus.noise.emit(global_position, intensity, "Player")

func play_animation(anim_name : String) -> void:
	if anim_name == "":
		return

	var animation_player : AnimationPlayer = get_node_or_null("AnimationPlayer")
	if animation_player == null:
		return

	if not animation_player.has_animation(anim_name):
		return

	if animation_player.current_animation == anim_name and animation_player.is_playing():
		return

	animation_player.play(anim_name, anim_blend_time)

func play_footstep() -> void:
	footstep_audio.pitch_scale = randf_range(0.9, 1.1)
	footstep_audio.play()
