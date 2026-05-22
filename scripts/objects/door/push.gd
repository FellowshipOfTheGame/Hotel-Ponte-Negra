extends Door

@export var force_max : float = 10

var collision : CollisionShape3D
var mesh : MeshInstance3D
var force : float

signal pushing(current : float)

func _on_interact(_interactor: Node):
	if !aberta: 
		force += 1
		pushing.emit(force)
	
func _ready() -> void:
	init()
	
	collision = $CollisionShape3D
	mesh = $Mesh
	aberta = false
	
func _physics_process(_delta: float) -> void:
	if !aberta and force >= force_max:
		force = 0
		pushing.emit(force)
		
		open()
		
	if !aberta and force > 0:
		force = max(force-0.05, 0)
		pushing.emit(force)
		
func get_force_max() -> float:
	return force_max

	
