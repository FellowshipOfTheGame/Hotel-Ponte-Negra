extends Sprite3D

@onready var view : Viewport = $UI
var playerState : PlayerState
var bar : TextureProgressBar
var tween : Tween

func _ready()->void:
	playerState = get_tree().get_first_node_in_group("Player").get_node_or_null("State Machine/PlayerWalking")
	texture = view.get_texture()
	bar = view.get_child(0)
	if bar is TextureProgressBar:
		bar.max_value = playerState.stamina_max
		bar.value = playerState.stamina

func changes()->void:
	if bar is TextureProgressBar:
		#print("Stamina na Barra: ", playerState.stamina)
		bar.value = playerState.stamina
		
	
