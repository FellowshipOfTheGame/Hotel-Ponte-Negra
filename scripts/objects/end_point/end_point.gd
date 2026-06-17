extends Door

@export var font_size : float = 30
@export var proxima_cena: String

var has_key : bool
var key : Interactable
var label_text : Label

func _ready() -> void:
	init()
	has_key = false
	
	label_text = get_node_or_null("../../../CanvasLayer/Text")
	key = get_node_or_null("../../Objetos/Chave")
	
	if key: 
		key.get_key.connect(get_key)
	
func get_key():
	print("Pegou a chave!")
	has_key = true

func _on_interact(_interactor: Node):
	if not label_text:
		push_error("Label de texto não encontrado!")
		return
	
	if has_key:
		print("Abrindo a porta...")
		#open()
		
		#await get_tree().create_timer(0.1).timeout
		SceneManager.carregar_fase(proxima_cena)

	else:
		label_text.add_theme_font_size_override("font_size", font_size)
		label_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_text.text = "Esta porta está trancada."
		label_text.visible = true
		
		await get_tree().create_timer(2).timeout
		
		label_text.visible = false
