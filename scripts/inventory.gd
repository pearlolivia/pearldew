extends Control

## INVENTORY UI

@onready var slots: Array = $Container/GridContainer.get_children()
@onready var inventory = $"." # top level parent node
@onready var inventory_data: Inventory = preload("res://resources/inventory/default.tres")

var is_open := false

func _ready() -> void:
	# update inventory with default data
	inventory_data.update.connect(update_slots)
	update_slots()

func update_slots():
	# loop through all slots
	for i in range(min(inventory_data.slots.size(), slots.size())):
		# add slot data to slot scene
		slots[i].update(inventory_data.slots[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.is_action_pressed("change_slot")):
		var key = int(event.as_text_key_label())
		inventory_data.set_selected(key - 1)
			
func open():
	inventory.visible = true
	is_open = true

func close():
	inventory.visible = false
	is_open = false
