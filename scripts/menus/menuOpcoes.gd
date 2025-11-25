extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		voltar()

func voltar() -> void:
	const  confPath = "user://config"
	var conf = ConfigFile.new()
	conf.load(confPath)
	for acao in InputMap.get_actions():
		if!(InputMap.action_get_events(acao).is_empty()
			or acao.begins_with("ui_")):
			var event := InputMap.action_get_events(acao)[0]
			conf.set_value("controles",acao,event.as_text().get_slice(" ",0))
	conf.save(confPath)

	$'..'/Container.visible=true
	queue_free()
