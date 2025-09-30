extends CharacterBody3D

@export var velocidade : float = 10

func _process(delta : float)->void:
	var movX : int = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var movZ : int = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var movimento = Vector3(movX, 0, movZ).normalized() * (velocidade * delta) #vetor indica a nova posição e por isso é multiplicado por algo de dimensão de comprimento 
	position += movimento
