extends Control

const confPath = "user://config"

func _init() -> void: # funcao load()
	if!FileAccess.file_exists(confPath):return
	var conf := ConfigFile.new();conf.load(confPath)
	for acao in conf.get_section_keys("controles"):
		var key :String= conf.get_value("controles",acao)
		var event:=InputMap.action_get_events(acao)[0]
		if event is InputEventKey:
			event.keycode=OS.find_keycode_from_string(key)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		voltar()

func voltar() -> void:
	save()
	$'..'/Container.visible=true
	queue_free()

func save()->void:
	var conf := ConfigFile.new();conf.load(confPath)

	for acao in InputMap.get_actions():
		if acao.begins_with("ui_"): return
		if InputMap.action_get_events(acao).is_empty(): return

		var event := InputMap.action_get_events(acao)[0]
		var text := event.as_text()
		if event is InputEventKey:
			text=text.get_slice(" ",0)
		elif event is InputEventJoypadMotion:
			text=text.get_slice("(",1).get_slice(",",0)
		conf.set_value("controles",acao,text)
	conf.save(confPath)
