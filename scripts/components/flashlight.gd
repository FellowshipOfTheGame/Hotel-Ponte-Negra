extends SpotLight3D

const danger_color : Color = Color(1,0,0) #Cor da luz quando houver inimigos especiais próximos
const normal_color : Color = Color(255, 255, 255)
var count_special_enemy : int

func _ready() -> void:
	visible = false
	count_special_enemy = 0
	
func _physics_process(delta: float) -> void:
	var input : int = Input.is_action_just_pressed("lanterna")
	if input:
		visible = !visible 
