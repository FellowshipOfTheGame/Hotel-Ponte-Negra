extends Node3D

@onready var audio_player = $AudioStreamPlayer3D

func _process(delta: float) -> void:
	EventBus.noise.emit(global_position, 15.0)

func _on_porta_tree_exited() -> void:
	print("Volume: " + str(audio_player.volume_db))
	audio_player.volume_db = 10
	print("Volume: " + str(audio_player.volume_db))
