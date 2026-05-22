extends Door

@export var font_size : float = 30

var has_key : bool
var key : Interactable
var label_text : Label

func _ready()->void:
	init()
	
	has_key = false
	label_text = $"../Text" 
	
	key = $"../Chave"
	if not key: 
		return
	key.get_key.connect(get_key)
	
func get_key():
	print("eita")
	has_key = true

func _on_interact(_interactor: Node):
	if not label_text or (not has_key and not key):
		return
	
	if has_key:
		print("oi")
		open()
		
		await get_tree().create_timer(1.5).timeout
		
		get_tree().change_scene_to_file("res://scenes/menus/menuPrincipal.tscn")

	else:
		label_text.text = "Esta porta está trancada."
		label_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_text.add_theme_font_size_override("Porta", font_size)
		label_text.visible = true
		
		await get_tree().create_timer(2).timeout
		
		label_text.visible = false
