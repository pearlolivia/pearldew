extends NinePatchRect

 # INVENTORY SLOT UI
@onready var ItemSprite: Sprite2D = $Container/Item
@onready var QuantityText: Label = $Container/Quantity
@onready var Selected: Sprite2D = $isSelected
@onready var Index: Label = $Container/Index
@onready var inventory: Inventory = preload("res://resources/inventory/default.tres")

@export var is_main := true

var items: Array[Item]
# TO DO: add items as created
var _crops_dir := DirAccess.open("res://resources/items/crops/")

func _init() -> void:
	# get all crop items
	for _file: String in _crops_dir.get_files():
		if (_file.get_extension() == "tres"):
			var _item := ResourceLoader.load(_crops_dir.get_current_dir() + "/" + _file)
			items.push_back(_item)

func _ready() -> void:
	if (is_main == false):
		$isSelected.visible = false

func update(slot: Slot):
	if !slot.item:
		QuantityText.visible = false
		ItemSprite.texture = null
		Selected.visible = false
	elif slot.item.is_tool == true:
		QuantityText.visible = false
		ItemSprite.texture = slot.item.texture
	else:
		QuantityText.visible = true
		ItemSprite.texture = slot.item.texture
		QuantityText.text = str(slot.quantity)
		
	if (slot.is_selected):
		Selected.visible = true
	else:
		Selected.visible = false
	
	Index.text = str(slot.index)

func _on_container_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed and is_main):
		inventory.set_selected(int(self.Index.text))
