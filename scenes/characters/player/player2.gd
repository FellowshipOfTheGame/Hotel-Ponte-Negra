extends CharacterBody3D

@export var cam : Camera3D
var stateMachina : StateMachine
var interaction_shapecast : ShapeCast3D


func _ready()->void:
	stateMachina = $"State Machine"
	for child in stateMachina.get_children():
		if child is PlayerState:
			child.changes_stamina.connect($Sprite3D.changes)
	interaction_shapecast = $ActionComponent
	
func _process(delta : float)->void:
	check_for_interaction()
	gravity_apply(delta)

func check_for_interaction() -> void:
	if not interaction_shapecast:
		return

	if Input.is_action_just_pressed("interacao"):
		interaction_shapecast.force_shapecast_update()
		
		if interaction_shapecast.is_colliding():
			var collider = interaction_shapecast.get_collider(0)
			if collider is Interactable:
				print("Player interagiu com: ", collider.name)
				collider._on_interact(self)
			else:
				print("Não colidiu")

func gravity_apply(delta : float):
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	self.velocity.y -= gravity * delta
