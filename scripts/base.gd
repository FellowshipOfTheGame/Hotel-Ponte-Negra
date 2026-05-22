extends Node3D

@onready var player = $Player
@onready var stamina = $Stamina
@onready var key = $Chave
@onready var door = $sala/porta_emperrada
@onready var force = $Forca
@onready var has_key = false

func _ready() -> void:
	stamina.max_value = player.get_stamina_max()
	force.max_value = door.get_forca_max()

	player.player_stamina_changed.connect(stamina.value_changed)
	door.empurrando.connect(force.value_changed)
	key.get_key.connect(get_key)
	
func get_key() -> void:
	has_key = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_pausa"):
		add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
		get_tree().paused=true
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()
