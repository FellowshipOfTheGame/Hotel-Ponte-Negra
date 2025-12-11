extends TextureProgressBar

func _ready() -> void:
	value = max_value
	size.x
	
func _value_changed(new_value: float) -> void:
	value = new_value
