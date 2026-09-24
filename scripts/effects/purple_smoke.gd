extends GPUParticles3D

func _ready() -> void:
	finished.connect(queue_free)
	restart()
