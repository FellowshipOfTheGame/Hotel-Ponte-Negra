extends EnemyState
class_name EnemyChasing

@export var speed: float = 5.0

func Enter():
	super.Enter() 

func Physics_Update(delta: float):
	if player == null:
		return
	move_to_position(player.global_position, speed,1 ,delta)
