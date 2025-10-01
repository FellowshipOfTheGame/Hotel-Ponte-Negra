extends CharacterBody3D

@export var velocidade:float = 10
@export var vel_ang:float = 3
var rad:float = 0

func _process(delta:float)->void:
	var movA:int = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	rad += movA * vel_ang * delta
	if rad > 2*PI:
		rad -= 2*PI
	elif rad < 0:
		rad += 2*PI
	var mov:float = float(Input.is_action_pressed("ui_up")) - float(Input.is_action_pressed("ui_down"))
	var movimento:Vector3
	if(mov < 0):
		movimento = Vector3(sin(rad)*mov, 0, cos(rad)*mov).normalized()*velocidade*delta*0.3
	else:
		movimento = Vector3(sin(rad)*mov, 0, cos(rad)*mov).normalized()*velocidade*delta
	position += movimento
	 
