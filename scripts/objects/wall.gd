extends Obstacle

@onready var children = get_children() 

func _shape_enter()->void:
	var tween = create_tween().set_parallel(true)
	
	for c in children:
		if c is GeometryInstance3D:
			tween.tween_property(c, "transparency", 0.85, 0.2)
		
func _shape_exit()->void:
	var tween = create_tween().set_parallel(true)
	
	for c in children:
		if c is GeometryInstance3D:
			tween.tween_property(c, "transparency", 0, 0.2)
