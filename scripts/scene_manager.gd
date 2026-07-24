extends Node

var cena_transicao = preload("res://scenes/levels/TransitionDoor.tscn")
var em_transicao : bool = false

func carregar_fase(caminho_nova_fase: String):
	if em_transicao:
		return
		
	em_transicao = true
	
	get_tree().paused = true

	var transicao = cena_transicao.instantiate()
	
	transicao.process_mode = Node.PROCESS_MODE_ALWAYS 
	get_tree().root.add_child(transicao)
	
	await transicao.transicao_concluida

	get_tree().change_scene_to_file(caminho_nova_fase)
	
	await get_tree().process_frame
	
	transicao.queue_free()
	
	get_tree().paused = false
	em_transicao = false
