extends CharacterBody3D

@export var velocidade:float = 10
@export var vel_ang:float = 1
var rad:float = 0

func _process(delta:float)->void:
	var movA:int = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	rad += movA * vel_ang * delta
	if rad > 2*PI:
		rad -= 2*PI
	elif rad < 0:
		rad += 2*PI
	var mov = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))*0.3
	var movimento = Vector3(sin(rad)*mov, 0, cos(rad)*mov).normalized()*velocidade*delta
	position += movimento
	 
