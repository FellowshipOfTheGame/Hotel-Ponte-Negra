extends Node3D

@onready var player = $Player
@onready var stamina = $Stamina

func _ready() -> void:
	stamina.max_value = player.stamina_bar_max #setando o valor máximo e inicial da stamina
	player.player_stamina_changed.connect(stamina._value_changed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
		get_viewport().set_input_as_handled()
