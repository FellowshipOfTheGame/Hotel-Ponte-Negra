extends TextureProgressBar

func _ready() -> void:
	value = 0
	visible = false

func value_changed(current : float) -> void:
	value = current
	
	if value > 0:
		visible = true
	else:
		visible = false
