extends OmniLight3D

var energy_max : int
@onready var incs = [-5, -4, 4, 5]

func _ready()->void:
	light_energy = 4
	energy_max = 6

func _process(delta: float) -> void:
	light_energy =  min(max(light_energy + 2 * delta * incs[randi_range(0, incs.size()-1)], 0), energy_max)
