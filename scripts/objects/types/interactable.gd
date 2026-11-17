extends StaticBody3D
class_name Interactable

## Texto mostrado na tela quando o jogador está perto (ex.: "Abrir", "Pegar chave").
@export var prompt_text: String = "Interagir"
## Desligue em objetos que não devem brilhar (ex.: paredes interativas).
@export var highlight_enabled: bool = true
@export var outline_color: Color = Color(1.0, 1.0, 1.0, 1.0)
## Espessura do contorno em "unidades de tela" (constante, não depende da escala do modelo).
@export_range(0.001, 0.02, 0.001) var outline_thickness: float = 0.010

const OUTLINE_SHADER_CODE := """
shader_type spatial;
render_mode unshaded, cull_front;

uniform vec4 outline_color : source_color = vec4(1.0, 0.85, 0.3, 1.0);
uniform float thickness = 0.005;

void vertex() {
	// Expande o casco na direção da normal, em espaço de tela,
	// para a largura do contorno ser constante mesmo com escala 0.02 etc.
	vec4 clip = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 view_normal = normalize(mat3(MODELVIEW_MATRIX) * NORMAL);
	vec2 dir = (PROJECTION_MATRIX * vec4(view_normal, 0.0)).xy;
	if (length(dir) > 0.0001) {
		dir = normalize(dir);
		dir.x *= VIEWPORT_SIZE.y / VIEWPORT_SIZE.x;
		clip.xy += dir * thickness * clip.w;
	}
	POSITION = clip;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
"""

static var _outline_shader: Shader

var _outline_material: ShaderMaterial
var _meshes: Array[MeshInstance3D] = []
var _meshes_collected: bool = false

func _on_interact(_interactor: Node):
	print("Este objeto interativo não tem uma ação definida.")
	pass # Classes filhas vão sobrescrever isso

## Texto que o player exibe na tela. Filhas podem sobrescrever para texto dinâmico
## (ex.: porta mostrar "Abrir" ou "Fechar" conforme o estado).
func get_prompt() -> String:
	return prompt_text

## Chamado pelo Player quando este objeto entra/sai do alcance de interação.
## Lazy de propósito: as classes filhas (Door, Root...) sobrescrevem _ready()
## sem chamar super(), então não dá pra depender de _ready aqui.
func set_highlighted(on: bool) -> void:
	if on and not highlight_enabled:
		return

	_ensure_outline_ready()

	for mesh in _meshes:
		if is_instance_valid(mesh):
			mesh.material_overlay = _outline_material if on else null

func _ensure_outline_ready() -> void:
	if not _meshes_collected:
		_meshes_collected = true
		for child in find_children("*", "MeshInstance3D", true, false):
			_meshes.append(child as MeshInstance3D)

	if _outline_material == null:
		if _outline_shader == null:
			_outline_shader = Shader.new()
			_outline_shader.code = OUTLINE_SHADER_CODE
		_outline_material = ShaderMaterial.new()
		_outline_material.shader = _outline_shader

	# Atualiza sempre, assim mudar o export em runtime/inspector vale na hora
	_outline_material.set_shader_parameter("outline_color", outline_color)
	_outline_material.set_shader_parameter("thickness", outline_thickness)
