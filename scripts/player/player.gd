extends CharacterBody3D

@onready var alarm_area: Area3D = $Alarm/AlarmArea
@onready var interaction_shapecast: ShapeCast3D = $"InteractionShapecast"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var stamina_bar_max : float

# Melhor fazer Game Manager:
const GameOverMenu = preload("res://scenes/menus/menuGameOver.tscn")
const BloodOverlay = preload("res://scenes/ui/blood_overlay.tscn")

signal player_stamina_changed(stamina_current : float, status_tired : bool) #mesmo objetivo de stamina_changed, porém reencaminha para a árvore da cena
@warning_ignore("unused_signal")
signal spacial_monster_nearby

var step_delay : float = 0.5
var step_timer: float = 0.0

func _ready() -> void:
	for child in $"State Machine".get_children(): #conectando o sinal que indica a mudança do valor da stamina
		if child is PlayerState:
			stamina_bar_max = child.stamina_max
			child.stamina_changed.connect(stamina_changed_from_child)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	handle_movement(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interacao"):
		check_for_interaction()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			die()
	
func get_stamina_max():
	return stamina_bar_max

func stamina_changed_from_child(stamina_current : float, status_tired : bool): #recaminhando sinal de mudança da stamina
	player_stamina_changed.emit(stamina_current, status_tired)
	
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

func handle_movement(delta):
	move_and_slide()
	if is_on_floor() and velocity.length() > 0.1:
		step_timer -= delta
		if step_timer <=0:
			make_noise()
			step_timer = step_delay
	else:
		step_timer = 0

func make_noise():
	EventBus.noise.emit(global_position, 5.0, "Player")
	#print("Emitiu som")
	
func die():
	print("Morreu!")
	velocity = Vector3.ZERO
	var blood = BloodOverlay.instantiate()
	get_tree().current_scene.add_child(blood)
	#dead State!
	$AnimationPlayer.play("die")
	GameState.has_key = false
	await $AnimationPlayer.animation_finished
	#Melhor colocar em Game Manager:
	var menu = GameOverMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	get_tree().paused = true

#func _input(event):
	#if awaiting_rebind != "" and event is InputEventKey and event.pressed and not event.echo:
		#set_new_key(awaiting_rebind, event.physical_keycode)
		#print(awaiting_rebind, "was rebound to ", event.as_text())
		#awaiting_rebind = ""
