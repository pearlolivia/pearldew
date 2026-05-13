extends CharacterBody2D

const SPEED = 100
var input_dir: Vector2
var lastDirection = 'down'
var isToolPlaying = false
var pauseIdle := false
var currentTool: int

@onready var inventory: Inventory = preload("res://resources/inventory/default.tres")

signal tool_use(tool: int, pos: Vector2)
signal plant_seed(crop: Item, pos: Vector2, slotIdx: int)

func _ready() -> void:
	var main_node = get_parent()
	main_node.play_harvest_animation.connect(play_pick_up_animation)
	
func _physics_process(_delta):
	# keyboard input
	input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * SPEED
	
	# if tool action in progress - do not move or play other animations
	if (isToolPlaying == true or pauseIdle == true):
		return
	
	# moves node and detects collision objects
	move_and_slide()
	
	# animation
	if (Input.is_action_pressed("down")):
		$AnimatedSprite2D.play("walk_down")
		lastDirection = 'down'
	elif (Input.is_action_pressed("up")):
		$AnimatedSprite2D.play("walk_up")
		lastDirection = 'up'
	elif (Input.is_action_pressed("left")):
		$AnimatedSprite2D.play("walk_left")
		lastDirection = 'left'
	elif (Input.is_action_pressed("right")):
		$AnimatedSprite2D.play("walk_right")
		lastDirection = 'right'
	else:
		if (lastDirection == 'up'):
			$AnimatedSprite2D.play("idle_back")
		elif (lastDirection == 'down'):
			$AnimatedSprite2D.play("idle_front")
		elif (lastDirection == 'left'):
			$AnimatedSprite2D.play("idle_left")
		elif (lastDirection == 'right'):
			$AnimatedSprite2D.play("idle_right")

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("action")):
		var selectedSlot = inventory.get_selected()
		if (!selectedSlot.item):
			return
		if (selectedSlot.item.tool_number):
			currentTool = selectedSlot.item.tool_number
			match selectedSlot.item.tool_number:
				Global.Tools.Hoe:
					isToolPlaying = true
					if (lastDirection == 'up'):
						$AnimatedSprite2D.play("hoe_back")
					elif (lastDirection == 'down'):
						$AnimatedSprite2D.play("hoe_front")
					elif (lastDirection == 'left'):
						$AnimatedSprite2D.play("hoe_left")
					elif (lastDirection == 'right'):
						$AnimatedSprite2D.play("hoe_right")
				Global.Tools.Watering_Can:
					isToolPlaying = true
					if (lastDirection == 'up'):
						$AnimatedSprite2D.play("water_back")
					elif (lastDirection == 'down'):
						$AnimatedSprite2D.play("water_front")
					elif (lastDirection == 'left'):
						$AnimatedSprite2D.play("water_left")
					elif (lastDirection == 'right'):
						$AnimatedSprite2D.play("water_right")
		elif ('seeds' in selectedSlot.item.name.to_lower()):
			var crop = selectedSlot.item
			plant_seed.emit(crop, position + input_dir * 8 + Vector2(4, 0), selectedSlot.index)
			
func _on_player_animation_finished() -> void:
	if (isToolPlaying == true):
		tool_use.emit(currentTool, position + input_dir * 4 + Vector2(4, 0))
		# reset
		isToolPlaying = false
		currentTool = 0
	if (pauseIdle == true):
		pauseIdle = false

func play_pick_up_animation():
	pauseIdle = true
	if (lastDirection == 'up'):
		$AnimatedSprite2D.play("pick_up_back")
	elif (lastDirection == 'down'):
		$AnimatedSprite2D.play("pick_up_front")
	elif (lastDirection == 'left'):
		$AnimatedSprite2D.play("pick_up_left")
	elif (lastDirection == 'right'):
		$AnimatedSprite2D.play("pick_up_right")
