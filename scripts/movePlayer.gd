extends CharacterBody3D

@export var velocidade : float = 10

func _process(delta : float)->void:
	var movX : float = Input.get_axis("movimento_esquerda", "movimento_direita")
	var movZ : float = Input.get_axis("movimento_frente", "movimento_tras")
	
	var movimento = Vector3(movX, 0, movZ).normalized() * (velocidade * delta) #vetor indica a nova posição e por isso é multiplicado por algo de dimensão de comprimento 
	position += movimento
