extends Door

var has_key : bool
const end : PackedScene = preload("res://scenes/menus/menuPrincipal.tscn")

func _ready()->void:
	init()
	
	has_key = false
	var key : Interactable = $"../Chave"
	
	key.get_key.connect(get_key)
	
func get_key():
	has_key = true

func _on_interact(_interactor: Node):
	if has_key:
		open()
		
		await get_tree().create_timer(1.5).timeout
		
		get_tree().change_scene_to_file(end.resource_path)
		queue_free()
