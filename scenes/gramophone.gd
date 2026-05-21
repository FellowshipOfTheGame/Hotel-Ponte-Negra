extends Node3D

@onready var audio_player = $AudioStreamPlayer3D
var noise_timer: float = 0.0
@export var noise_interval: float = 0.5 

func _process(delta: float) -> void:
	noise_timer -= delta
	if noise_timer <= 0.0:
		EventBus.noise.emit(global_position, 30.0, "Gramofone")
		noise_timer = noise_interval 

func _on_porta_tree_exited() -> void:
	print("Volume: " + str(audio_player.volume_db))
	audio_player.volume_db = 10
	print("Volume: " + str(audio_player.volume_db))
