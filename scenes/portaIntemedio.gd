extends Node3D

@onready var child : StaticBody3D = $StaticBody3D
@export var forca_max : float = 10

signal empurrando(current : float)

func _ready() -> void:
	child.empurrando.connect(empurrando_from_child)

func empurrando_from_child(current : float) -> void:
	empurrando.emit(current)

func get_forca_max() -> float:
	return forca_max
