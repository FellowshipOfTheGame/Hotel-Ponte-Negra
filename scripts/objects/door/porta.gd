extends Node3D

# Necessário em todo interagível
@onready var interactable: Area3D = $Interactable

func _ready() -> void:
	interactable.interact = _on_interact
# ================================================================

func _on_interact():
	print("It's locked!")
