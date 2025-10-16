extends Control

signal start

func _on_jogar_pressed():
	start.emit()


func _on_sair_pressed():
	get_tree().quit()
