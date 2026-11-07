extends Obstacle
class_name Wall

## Paredes com o mesmo ID somem e voltam juntas.
## Deixe vazio para a parede agir sozinha.
@export var id_grupo: StringName = &""
@export_range(0.0, 1.0) var transparencia_oculta: float = 0.85
@export var duracao_fade: float = 0.2

var _meshes: Array[GeometryInstance3D] = []
var _ocluindo: bool = false   # ESTA parede está entre a câmera e o player
var _alvo: float = 0.0        # transparência para a qual o fade está indo
var _tween: Tween


func _ready() -> void:
	# Pega todos os meshes descendentes (inclusive de cenas instanciadas)
	for c in find_children("*", "GeometryInstance3D", true, false):
		_meshes.append(c as GeometryInstance3D)

	if id_grupo != &"":
		add_to_group(_nome_grupo())


func _nome_grupo() -> String:
	return "wall_group_" + String(id_grupo)


func _membros() -> Array:
	if id_grupo == &"":
		return [self]
	return get_tree().get_nodes_in_group(_nome_grupo())


func _shape_enter() -> void:
	_set_ocluindo(true)


func _shape_exit() -> void:
	_set_ocluindo(false)


func _set_ocluindo(valor: bool) -> void:
	if _ocluindo == valor:
		return
	_ocluindo = valor
	# Reavalia o grupo inteiro: some se QUALQUER parede estiver ocluindo
	for m in _membros():
		m._atualizar_fade()


func _atualizar_fade() -> void:
	var alguma_ocluindo := false
	for m in _membros():
		if m._ocluindo:
			alguma_ocluindo = true
			break
	_fade_para(transparencia_oculta if alguma_ocluindo else 0.0)


func _fade_para(alvo: float) -> void:
	if is_equal_approx(alvo, _alvo):
		return
	_alvo = alvo

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)

	for mesh in _meshes:
		_tween.tween_property(mesh, "transparency", alvo, duracao_fade)
