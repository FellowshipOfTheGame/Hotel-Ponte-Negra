extends PlayerState

# Melhor fazer Game Manager:
const GameOverMenu = preload("res://scenes/menus/menuGameOver.tscn")
const BloodOverlay = preload("res://scenes/ui/blood_overlay.tscn")

func Enter():
	init()
	
	player.velocity = Vector3.ZERO
	
	var blood = BloodOverlay.instantiate()
	
	get_tree().current_scene.add_child(blood)
	
	player.get_node("AnimationPlayer").play("die")
	
	await player.get_node("AnimationPlayer").animation_finished
	
	#Melhor colocar em Game Manager:
	var menu = GameOverMenu.instantiate()
	
	get_tree().current_scene.add_child(menu)
	
	tired = false
	stamina_changed.emit(stamina, false)
	await get_tree().create_timer(0.7).timeout
	
	get_tree().paused = true
	
	stamina = stamina_max
	
	#stamina_changed.emit(player.stamina_bar_max, false)
