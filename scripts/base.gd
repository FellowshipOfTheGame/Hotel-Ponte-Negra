extends Node3D

@onready var player = get_node_or_null("Player")
@onready var stamina = get_node_or_null("CanvasLayer/Stamina")
@onready var door = get_node_or_null("sala/PortaEmperrada")
@onready var force = get_node_or_null("Forca")
@onready var camera = get_node_or_null("Camera3D")

func _ready() -> void:
	if camera:
		camera.make_current()
		
	if player and stamina:
		stamina.max_value = player.get_stamina_max()
		player.player_stamina_changed.connect(stamina.value_changed)
		
	if door and force:
		force.max_value = door.get_force_max()
		door.pushing.connect(force.value_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_pausa"):
		add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
		get_tree().paused=true
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()
