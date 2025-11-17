
extends CSGPolygon3D 

class_name Obstacle

var tween: Tween

func tornar_transparente():
	if tween and tween.is_valid():
		tween.kill()
	if material:
		tween = create_tween()
		tween.tween_property(material, "albedo_color", Color(1, 1, 1, 0.2), 0.3).from_current()
	else:
		push_warning("Obstáculo (CSGPolygon3D) não tem material atribuído.")

func tornar_opaco():
	if tween and tween.is_valid():
		tween.kill()
		
	if material:
		tween = create_tween()
		tween.tween_property(material, "albedo_color", Color(1, 1, 1, 1.0), 0.3).from_current()
	else:
		push_warning("Obstáculo (CSGPolygon3D) não tem material atribuído.")
