extends Button

var resolucao :Vector2i

func _init() -> void:
	var partes := name.split("x")
	resolucao = Vector2i(int(partes[0]), int(partes[1]))
	text = "%d x %d" % [resolucao.x, resolucao.y]

func _ready() -> void:
	button_pressed = get_window().size == resolucao

func _pressed() -> void:
	get_window().size = resolucao
	var tela := DisplayServer.screen_get_size()
	get_window().position = (tela - resolucao) / 2
