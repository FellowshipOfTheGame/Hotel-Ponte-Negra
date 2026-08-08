extends Obstacle

@onready var children = get_children() 

func _shape_enter()->bool:
	var tween = create_tween().set_parallel(true)
	
	var flag : bool = true
	
	for c in children:
		if c is GeometryInstance3D:
			tween.tween_property(c, "transparency", 0.85, 0.2)
			
			if c.transparency != 0.85:
				flag = false
		
	return flag
		
func _shape_exit()->bool:
	var tween = create_tween().set_parallel(true)
	
	var flag : bool = true
	
	for c in children:
		
		if c is GeometryInstance3D:
			tween.tween_property(c, "transparency", 0, 0.2)
			
			if c.transparency != 0:
				flag = false
				
	return flag
