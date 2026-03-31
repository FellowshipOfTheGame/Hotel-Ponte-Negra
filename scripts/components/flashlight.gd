extends SpotLight3D

const danger_color : Color = Color(1,0,0) #Cor da luz quando houver inimigos especiais próximos
const normal_color : Color = Color(255, 255, 255)
var count_special_enemy : int

func _ready() -> void:
	visible = false
	count_special_enemy = 0
	
func special_enemy_entered() -> void:
	count_special_enemy += 1

func special_enemy_exited() -> void:
	count_special_enemy -= 1

func _physics_process(delta: float) -> void:
	var input : int = Input.is_action_just_pressed("lanterna")
	if input:
		visible = !visible 

func _process(delta : float) -> void:
	if count_special_enemy: #Se há algum inimigo especial por perto 
		light_color.r = move_toward(light_color.r, danger_color.r, delta)
		light_color.b = move_toward(light_color.b, danger_color.b, delta)
		light_color.g = move_toward(light_color.g, danger_color.g, delta)
	else:
		light_color.r = move_toward(light_color.r, normal_color.r, delta)
		light_color.b = move_toward(light_color.b, normal_color.b, delta)
		light_color.g = move_toward(light_color.g, normal_color.g, delta)
