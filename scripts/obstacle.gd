# Obstaculo.gd (CORRIGIDO)
extends StaticBody3D

class_name Obstacle

@onready var mesh: MeshInstance3D = $MeshInstance3D
var tween: Tween

func tornar_transparente():
	if tween and tween.is_valid():
		tween.kill()

	var material = mesh.get_active_material(0)
	if material:
		tween = create_tween()
		tween.tween_property(material, "albedo_color", Color(1, 1, 1, 0.2), 0.3).from_current()

func tornar_opaco():
	if tween and tween.is_valid():
		tween.kill()
		
	var material = mesh.get_active_material(0)

	if material:
		tween = create_tween()
		tween.tween_property(material, "albedo_color", Color(1, 1, 1, 1.0), 0.3).from_current()
