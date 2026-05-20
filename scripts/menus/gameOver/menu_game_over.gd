extends Control

const inicio:PackedScene=preload("res://scenes/menus/menuPrincipal.tscn")

func _ready():
	$ColorRect.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.6, 0.5)

func reviver() -> void:
	#Aplicar lógica de save quando tivermos
	get_tree().paused = false
	get_tree().reload_current_scene()

func menuPrincipal() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/menuPrincipal.tscn")
	
func sair() -> void:
	print("Saiu")
	get_tree().quit()
