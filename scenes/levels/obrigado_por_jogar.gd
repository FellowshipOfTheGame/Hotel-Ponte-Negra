extends CanvasLayer

@onready var label: Label = $Label

@export var tempo_tela: float = 2.0  

func _ready() -> void:
	label.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 2.5)
	
	await get_tree().create_timer(tempo_tela).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(label, "modulate:a", 0.0, 1.5)
	await tween_out.finished
	
	get_tree().change_scene_to_file("res://scenes/menus/menuPrincipal.tscn")
