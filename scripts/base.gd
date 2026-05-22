extends Node3D

@onready var player = $Player
@onready var stamina = $Stamina
@onready var door = $sala/PortaEmperrada
@onready var force = $Forca

func _ready() -> void:
	stamina.max_value = player.get_stamina_max()
	force.max_value = door.get_force_max()

	player.player_stamina_changed.connect(stamina.value_changed)
	door.pushing.connect(force.value_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_pausa"):
		add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
		get_tree().paused=true
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()
