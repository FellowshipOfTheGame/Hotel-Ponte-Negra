extends Node

var cena_transicao = preload("res://scenes/TransitionDoor.tscn")

func carregar_fase(caminho_nova_fase: String):
	var transicao = cena_transicao.instantiate()
	get_tree().root.add_child(transicao)

	await transicao.transicao_concluida
	
	get_tree().change_scene_to_file(caminho_nova_fase)
	
	await get_tree().process_frame
	
	transicao.queue_free()
