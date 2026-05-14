extends Area2D

var is_open := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Slot.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if (body.name == 'Player' and is_open == false):
		is_open = true
		$AnimatedSprite2D.play('open')
		

func _on_body_exited(body: Node2D) -> void:
	if (body.name == 'Player' and is_open == true):
		is_open = false
		$AnimatedSprite2D.play('close')


func _on_animation_finished() -> void:
	print(is_open)
	if (is_open):
		$Slot.visible = true
	else:
		$Slot.visible = false
