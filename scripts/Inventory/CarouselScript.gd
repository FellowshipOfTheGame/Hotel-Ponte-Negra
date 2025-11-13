@tool
extends Node2D
class_name CarouselContainer

const slot = preload("res://scenes//Inventory//slot.tscn")

@export var spacing: float = 20.0

@export var wraparound_enabled: bool = false
@export var wraparound_radius: float = 300.0
@export var wraparound_height: float = 50.0

@export_range(0.0, 1.0) var opacity_strength: float = 0.35
@export_range(0.0, 1.0) var scale_strength: float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1

@export var smoothing_speed: float = 6.5
@export var selected_index: int = 0
@export var follow_button_focus: bool = false

@export var position_offset_node: Control = null

func _ready() -> void:
	var inv_data = preload("res://scripts/Inventory/inv_test.tres")
	populate_item_carousel(inv_data.slot_datas)

func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return
		
	#selected_index = clamp(selected_index, 0, position_offset_node.get_child_count()-1)
	
	for i in position_offset_node.get_children():
		if wraparound_enabled:
			var max_index_range = max(1, (position_offset_node.get_child_count() - 1) / 2.0)
			var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI
			var x = sin(angle) * wraparound_radius
			var y = cos(angle) * wraparound_radius
			var target_pos = Vector2(x, y-wraparound_height) - i.size/2.0
			i.position = lerp(i.position, target_pos, smoothing_speed * delta)
		else: 
			var position_x = 0
			if i.get_index() > 0:
				position_x = position_offset_node.get_child(i.get_index()-1).position.x + position_offset_node.get_child(i.get_index()-1).size.x + spacing
			i.position = Vector2(position_x, -i.size.y / 2.0)
			
		i.pivot_offset = i.size/2.0
		var target_scale = 1.0 - (scale_strength * abs(i.get_index()-selected_index))
		target_scale = clamp(target_scale, scale_min, 1.0)
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed*delta)
		
		var target_opacity = 1.0 - (opacity_strength * abs(i.get_index()-selected_index))
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed*delta)
		
		if i.get_index() == selected_index:
			i.z_index = 1
		else:
			i.z_index = -abs(i.get_index()-selected_index)
			
		if follow_button_focus and i.has_focus():
			selected_index = i.get_index()
			
	if wraparound_enabled:
		position_offset_node.position.x = lerp(position_offset_node.position.x, 0.0, smoothing_speed*delta)
	else:
		position_offset_node.position.x = lerp(position_offset_node.position.x, -(position_offset_node.get_child(selected_index).position.x + position_offset_node.get_child(selected_index).size.x/2.0), smoothing_speed*delta)

	if selected_index < 0:
		selected_index = position_offset_node.get_child_count()-1
		
	if selected_index > position_offset_node.get_child_count() - 1:
		selected_index = 0
		
	if Input.is_action_just_pressed("movimento_direita"):
		_right()
	
	if Input.is_action_just_pressed("movimento_esquerda"):
		_left()
		
func _left():
	selected_index -= 1
		
func _right():
	selected_index += 1

func populate_item_carousel(slot_datas: Array[SlotData]) -> void:
	for child in position_offset_node.get_children():
		child.queue_free()
		
	for slot_data in slot_datas:
		var slot = slot.instantiate()
		position_offset_node.add_child(slot)
		
		if slot_data:
			slot.set_slot_data(slot_data)
