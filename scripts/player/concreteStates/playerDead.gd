extends PlayerState

# Melhor fazer Game Manager:
const GameOverMenu = preload("res://scenes/menus/menuGameOver.tscn")
const BloodOverlay = preload("res://scenes/ui/blood_overlay.tscn")

func Enter():
	init()
	player.velocity = Vector3.ZERO
	var blood = BloodOverlay.instantiate()
	get_tree().current_scene.add_child(blood)
	#dead State!
	$AnimationPlayer.play("die")
	GameState.has_key = false
	await $AnimationPlayer.animation_finished
	#Melhor colocar em Game Manager:
	var menu = GameOverMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	get_tree().paused = true
