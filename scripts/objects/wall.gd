extends Obstacle

@onready var children = get_children() 

func _ray_enter()->void:
	for c in children:
		if c is GeometryInstance3D:
			c.transparency = min(0.85, c.transparency + 0.05)
		
func _ray_exit()->void:
	for c in children:
		if c is GeometryInstance3D:
			c.transparency = max(0, c.transparency - 0.05)
