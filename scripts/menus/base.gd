extends Node3D

@onready var player = $Player
@onready var stamina = $Stamina

func _ready() -> void:
	# 1. Define o valor máximo (usando a função que você criou no Player)
	stamina.max_value = player.get_stamina_max()
	
	# 2. Conecta o sinal filtrando os argumentos
	# Criamos uma função rápida que recebe (current, tired) e só usa o current
	player.player_stamina_changed.connect(func(current, _tired): 
		stamina.value = current
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		add_child(preload("res://scenes/menus/menuPausa.tscn").instantiate())
		get_viewport().set_input_as_handled()
