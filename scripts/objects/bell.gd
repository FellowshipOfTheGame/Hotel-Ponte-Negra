extends Interactable

@onready var on_cooldown := false

func _on_interact(_interactor: Node):
	if on_cooldown:
		return
	
	on_cooldown = true
	
	EventBus.noise.emit(position, 500, "Sino")
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	on_cooldown = false
