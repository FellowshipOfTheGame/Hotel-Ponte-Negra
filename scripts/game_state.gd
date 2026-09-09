extends Node

var items: Dictionary = {
	"key": 0
}

func add_item(item_id: String, amount: int = 1) -> void:
	var key = item_id.to_lower()
	if items.has(key):
		items[key] += amount
	else:
		items[key] = amount

func has_item(item_id: String, amount: int = 1) -> bool:
	var key = item_id.to_lower()
	return items.has(key) and items[key] >= amount

func use_item(item_id: String, amount: int = 1) -> bool:
	var key = item_id.to_lower()
	if has_item(key, amount):
		items[key] -= amount
		return true
	return false

func clear_inventory() -> void:
	items.clear()
