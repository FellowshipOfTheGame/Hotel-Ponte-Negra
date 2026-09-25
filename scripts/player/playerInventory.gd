extends Node
class_name PlayerInventory

var items: Dictionary = {}

signal item_changed(item_id: String, new_amount: int)

func add_item(item_id: String, amount: int = 1) -> void:
	var key := item_id.to_lower()
	items[key] = items.get(key, 0) + amount
	item_changed.emit(key, items[key])

func remove_item(item_id: String, amount: int = 1) -> bool:
	var key := item_id.to_lower()
	if not has_item(key, amount):
		return false

	items[key] -= amount
	item_changed.emit(key, items[key])
	return true

func has_item(item_id: String, amount: int = 1) -> bool:
	var key := item_id.to_lower()
	return items.has(key) and items[key] >= amount

func get_amount(item_id: String) -> int:
	var key := item_id.to_lower()
	return items.get(key, 0)

func clear_inventory() -> void:
	items.clear()
