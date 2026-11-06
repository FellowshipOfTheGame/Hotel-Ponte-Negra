extends Node
## Oclusão de áudio 3D: sons que atravessam parede/porta ficam abafados.
##
## O Godot NÃO faz oclusão por geometria (com ou sem teto na fase). Aqui um raycast
## do "ouvido" até cada AudioStreamPlayer3D conta quantas paredes/portas estão no
## meio. Se houver alguma, o som vai para uma bus com filtro passa-baixa e perde volume.
##
## Uso: registrar como Autoload com o nome "AudioOcclusion". Nenhuma cena precisa mudar.

const DEBUG := false

# --- Quem bloqueia o som ---
# Todo CollisionObject3D descendente de um nó com um destes nomes (Cena/Paredes,
# Cena/Portas) ganha a layer abaixo. Só ela entra no raycast, então chão, móveis
# e itens não abafam nada. A layer extra não muda colisão de física existente.
const OCCLUDER_PARENT_NAMES: PackedStringArray = ["Paredes", "Portas"]
const OCCLUDER_LAYER: int = 8

# --- Efeito ---
const MUFFLED_BUS: StringName = &"Muffled"
const MUFFLED_SEND: StringName = &"Master"   # se você tiver uma bus de SFX, troque aqui
const MUFFLED_CUTOFF_HZ: float = 2500.0      # menor = mais abafado (900 era bem forte)
const DB_DROP_PER_WALL: float = 2.0          # queda de volume por parede
const MAX_WALLS: int = 2                     # quantas paredes somam no volume
const FADE_SPEED: float = 6.0                # velocidade da transição abafado <-> limpo

# --- Ouvido (listener) ---
const LISTENER_HEIGHT: float = 1.5

class Source extends RefCounted:
	var base_db: float
	var base_bus: StringName
	var self_rid: RID
	var occlusion: float = 0.0
	var was_playing: bool = false
	var last_walls: int = -1

var _sources: Dictionary = {}   # AudioStreamPlayer3D -> Source
var _listener: AudioListener3D
var _player: Node3D
var _warned_no_player := false

func _ready() -> void:
	_setup_bus()
	
	# Ouvido no player (e não na câmera), com a orientação da câmera para o pan
	# esquerda/direita bater com a tela.
	_listener = AudioListener3D.new()
	_listener.name = "OcclusionListener"
	add_child(_listener)
	_listener.make_current()
	
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)
	
	# Se o jogo começa direto numa fase (F5/F6), os nós dela já entraram na árvore
	# antes deste _ready e o node_added não avisa. Por isso varremos tudo uma vez.
	_scan(get_tree().root)
	
	if DEBUG:
		print("[AudioOcclusion] ativo (autoload carregado)")

func _setup_bus() -> void:
	if AudioServer.get_bus_index(MUFFLED_BUS) != -1:
		return
	AudioServer.add_bus()
	var idx := AudioServer.bus_count - 1
	AudioServer.set_bus_name(idx, MUFFLED_BUS)
	AudioServer.set_bus_send(idx, MUFFLED_SEND)
	
	var lowpass := AudioEffectLowPassFilter.new()
	lowpass.cutoff_hz = MUFFLED_CUTOFF_HZ
	lowpass.db = AudioEffectFilter.FILTER_12DB   # 6DB = mais suave, 24DB = mais cortante
	AudioServer.add_bus_effect(idx, lowpass)

# ------------------------------------------------------------------ registro

func _on_node_added(node: Node) -> void:
	if node is AudioStreamPlayer3D:
		_register(node as AudioStreamPlayer3D)
	elif node is CollisionObject3D:
		_tag_if_occluder(node as CollisionObject3D)

func _on_node_removed(node: Node) -> void:
	if node is AudioStreamPlayer3D:
		_sources.erase(node)

func _scan(node: Node) -> void:
	_on_node_added(node)
	for child in node.get_children():
		_scan(child)

func _register(p: AudioStreamPlayer3D) -> void:
	if _sources.has(p):
		return
	if p.is_in_group("no_occlusion"):   # opt-out: coloque o player nesse grupo
		return
	var s := Source.new()
	s.base_db = p.volume_db
	s.base_bus = p.bus
	s.self_rid = _find_parent_body_rid(p)
	_sources[p] = s
	if DEBUG:
		print("[AudioOcclusion] som registrado: ", p.get_path())

func _tag_if_occluder(body: CollisionObject3D) -> void:
	var cur := body.get_parent()
	while cur:
		if OCCLUDER_PARENT_NAMES.has(String(cur.name)):
			body.set_collision_layer_value(OCCLUDER_LAYER, true)
			return
		cur = cur.get_parent()

# Corpo ao qual o som está preso (ex.: a porta que faz o "baque"). Ele é ignorado
# no raycast, senão a própria porta abafaria o som dela mesma.
func _find_parent_body_rid(n: Node) -> RID:
	var cur := n.get_parent()
	while cur:
		if cur is CollisionObject3D:
			return (cur as CollisionObject3D).get_rid()
		cur = cur.get_parent()
	return RID()

# ------------------------------------------------------------------ loop

func _process(_delta: float) -> void:
	if not is_instance_valid(_player) or not _player.is_inside_tree():
		_player = get_tree().get_first_node_in_group("Player") as Node3D
		if _player == null:
			if DEBUG and not _warned_no_player:
				print("[AudioOcclusion] aguardando player (nenhum nó no grupo 'Player')")
				_warned_no_player = true
			return
		_warned_no_player = false
		if DEBUG:
			print("[AudioOcclusion] player encontrado: ", _player.get_path())
	
	_listener.global_position = _player.global_position + Vector3.UP * LISTENER_HEIGHT
	
	var cam := get_viewport().get_camera_3d()
	if cam:
		# só o giro horizontal da câmera (mesma lógica do input_direction)
		_listener.global_basis = Basis(Vector3.UP, cam.global_rotation.y)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_player) or not _player.is_inside_tree():
		return
	
	var space := _listener.get_world_3d().direct_space_state
	var origin := _listener.global_position
	
	for key in _sources.keys():
		if not is_instance_valid(key):
			_sources.erase(key)
			continue
		
		var p := key as AudioStreamPlayer3D
		if not p.is_inside_tree():
			continue
		var s: Source = _sources[key]
		
		if not p.playing:
			if s.was_playing:
				s.was_playing = false
				s.occlusion = 0.0
				s.last_walls = -1
				_apply(p, s)   # devolve volume e bus originais
			continue
		
		var walls := _count_walls(space, origin, p.global_position, s.self_rid)
		var target := float(walls)
		
		if not s.was_playing:
			s.occlusion = target   # som novo já nasce abafado, sem fade
			s.was_playing = true
		else:
			s.occlusion = move_toward(s.occlusion, target, FADE_SPEED * delta)
		
		if DEBUG and walls != s.last_walls:
			print("[AudioOcclusion] %s -> %d parede(s) no caminho" % [p.get_path(), walls])
		s.last_walls = walls
		
		_apply(p, s)

func _apply(p: AudioStreamPlayer3D, s: Source) -> void:
	p.volume_db = s.base_db - s.occlusion * DB_DROP_PER_WALL
	p.bus = MUFFLED_BUS if s.occlusion >= 0.5 else s.base_bus

# Conta quantos corpos oclusores estão entre o ouvido e a fonte. Cada hit entra
# na lista de exclusão e o raio é lançado de novo até no máximo MAX_WALLS.
func _count_walls(space: PhysicsDirectSpaceState3D, from: Vector3, to: Vector3, self_rid: RID) -> int:
	var exclude: Array[RID] = []
	if self_rid.is_valid():
		exclude.append(self_rid)
	
	var mask := 1 << (OCCLUDER_LAYER - 1)
	var count := 0
	for i in MAX_WALLS:
		var query := PhysicsRayQueryParameters3D.create(from, to, mask, exclude)
		query.collide_with_areas = false
		var hit := space.intersect_ray(query)
		if hit.is_empty():
			break
		count += 1
		exclude.append(hit.rid)
	return count
