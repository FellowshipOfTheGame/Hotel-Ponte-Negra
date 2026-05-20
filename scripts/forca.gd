extends TextureProgressBar

func _ready() -> void:
	value = 0
	
func value_changed(current : float) -> void:
	value = current
	
func _process(delta: float) -> void:
	if value != 0:
		visible = true
	else:
		visible = false
