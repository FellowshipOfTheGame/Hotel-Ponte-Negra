extends Control

var anterior:Node

func _input(event: InputEvent) -> void:
	if event is InputEventAction:match event.action:
		"ui_cancel":
			voltar()

func voltar() -> void:
	$'..'/Container.visible=true
	queue_free()
