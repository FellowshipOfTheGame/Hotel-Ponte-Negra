extends Interactable

var collision:CollisionShape3D
var mesh:MeshInstance3D
var forca:float
var aberta:bool

signal empurrando(current : float)

func _on_interact(_interactor: Node):
	forca += 1
	empurrando.emit(forca)
	
func _ready() -> void:
	collision = $CollisionShape3D
	mesh = $Mesh
	aberta = false
	
func _physics_process(delta: float) -> void:
	if !aberta and forca >= 10:
		aberta = true
		collision.queue_free()
		mesh.queue_free()
		
		forca = 0
		empurrando.emit(forca)
		
	if !aberta and forca > 0:
		forca = max(forca-0.05, 0)
		empurrando.emit(forca)

	
