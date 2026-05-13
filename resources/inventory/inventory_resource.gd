extends Resource

class_name Inventory

@export var slots: Array[Slot]

# signal for UI
signal update()

func insert(item: Item):
	# does inventory already contain this item?
	var item_slots = slots.filter(func(slot): return slot.item == item)
	# if item already exists in inventory, add 1
	if (!item_slots.is_empty()):
		item_slots[0].quantity += 1
	else: 
		# find available slot
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		# if empty slots available
		if (!empty_slots.is_empty()):
			# add item to first available
			empty_slots[0].item = item
			empty_slots[0].quantity = 1
		else:
			return false
	# emit signal that inventory has been updated
	update.emit()

func remove(idx: int):
	# if quantity is going to be zero, clear slot
	if (slots[idx].quantity - 1 == 0):
		slots[idx].item = null
	
	slots[idx].quantity -= 1
	update.emit()
	
func set_selected(idx: int):
	# find currently selected slot
	var selected_slots = slots.filter(func(slot): return slot.is_selected == true)
	if (!selected_slots.is_empty()):
		# deselect
		selected_slots[0].is_selected = false
		
	slots[idx].is_selected = true
	update.emit()
	
func get_selected():
	var selected_slots = slots.filter(func(slot): return slot.is_selected == true)
	if (!selected_slots.is_empty()):
		return selected_slots[0]
	else:
		return null
