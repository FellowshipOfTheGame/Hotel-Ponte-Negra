extends TextureProgressBar

@export var max_stamina : float = 3
var status_tired: bool
var alpha : float
var flag : bool #se true, a transparência vai diminuir; se true, vai aumentar

func _ready() -> void:
	max_value = max_stamina
	value = max_value
	status_tired = false
	alpha = 1

func value_changed(new_value: float, new_status_tired : bool) -> void:
	value = new_value
	status_tired = new_status_tired

func _process(delta: float) -> void:
	if status_tired: 
		if flag: 
			alpha -= delta #diminuindo a transparência de pouco em pouco
		else:
			alpha += delta #diminuindo a transparência de pouco em pouco
			
		if alpha <= 0:
			flag = false #Vai começar a subir
			alpha = 0 #a transparência não pode ser negativa
		elif alpha >= 1: 
			flag = true #Vai começar a descer
			alpha = 1 #e não pode passar de 1
			
		set_modulate(Color(1,1,1, alpha)) #só a transparência se altera
	else:
		if alpha < 1:
			alpha = min(alpha + delta, 1)
			set_modulate(Color(1, 1, 1, alpha))
		flag = true
