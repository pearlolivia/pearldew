extends Area2D

@export var crop_type: Item
@export var is_watered: bool
var current_frame := 0
var total_frames: int
var fully_grown := false
var cropName: String

var playerInRange := false
var CROP_DICTIONARY = Global.CROP_DICTIONARY
var CYCLE_LENGTH = Global.PORTION_LENGTH

var inventory = preload("res://resources/inventory/default.tres")

var cropItems: Array[Item]
var _crops_dir := DirAccess.open("res://resources/items/crops/")

signal harvest()
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	$AnimatedSprite2D.stop()

func _init() -> void:
	# get all crop items
	for _file: String in _crops_dir.get_files():
		if (_file.get_extension() == "tres" and not 'seeds' in _file):
			var _item := ResourceLoader.load(_crops_dir.get_current_dir() + "/" + _file)
			cropItems.push_back(_item)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.value = $GrowthTimer.time_left
	var remaining_frames = total_frames - current_frame
	
	# initialise once crop_type loaded
	if (cropName != crop_type.name):
		cropName = crop_type.name.trim_suffix(' seeds')
		total_frames = CROP_DICTIONARY[cropName].frames
		var totalCycle = total_frames * CYCLE_LENGTH #seconds
		$AnimatedSprite2D.animation = cropName
		self.visible = true
		$GrowthTimer.wait_time = totalCycle
		$ProgressBar.max_value = totalCycle
	
	# if watered and at start of cycle - start growth	
	if (is_watered == true and $GrowthTimer.is_stopped() and fully_grown == false):
		$GrowthTimer.start()
		
	# if next stage reached during cycle - update sprite frame
	if ($GrowthTimer.time_left < (remaining_frames * CYCLE_LENGTH) and $GrowthTimer.is_stopped() == false and fully_grown == false):
		current_frame += 1
		$AnimatedSprite2D.frame += 1
	
	# if time complete and cycle in progress - complete growth
	if ($GrowthTimer.time_left < 0.5 and $GrowthTimer.is_stopped() == false):
		fully_grown = true
		$GrowthTimer.stop()

func _on_body_entered(body: Node2D) -> void:
	if (body.name == 'Player'):
		playerInRange = true

func _on_body_exited(body: Node2D) -> void:
	if (body.name == 'Player'):
		playerInRange = false

func _on_mouse_entered() -> void:
	if (fully_grown == false):
		$ProgressBar.visible = true

func _on_mouse_exited() -> void:
	$ProgressBar.visible = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.pressed and fully_grown == true and playerInRange == true):
		harvest.emit()
		var fully_grown_crop = cropItems.filter(func (item): return item.name == cropName)[0]
		inventory.insert(fully_grown_crop)
		
		# delete self from scene
		queue_free()
