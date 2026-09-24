extends ColorRect
class_name StunEffect

@export var pulse_color: Color = Color(0.6, 0.0, 0.0, 1.0)
@export var max_alpha: float = 0.35
@export var pulse_speed: float = 3.0

var _is_active: bool = false
var _time: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	color = pulse_color
	color.a = 0.0

func start_pulse() -> void:
	_is_active = true
	_time = 0.0
	visible = true

func stop_pulse() -> void:
	_is_active = false
	visible = false
	color.a = 0.0

func _process(delta: float) -> void:
	if not _is_active:
		return
	_time += delta * pulse_speed
	# sin vai de -1 a 1, remapeia pra 0 a 1
	var pulse = (sin(_time) + 1.0) / 2.0
	color.a = pulse * max_alpha
