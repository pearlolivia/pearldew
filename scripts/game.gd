extends Node2D

var hoedCoords: Array[Vector2i]
var wateredCoords: Array[Vector2i]
var cropCoords: Array[Vector2i]
var crop_scene: PackedScene = preload("res://scenes/crop.tscn")
var currentCrops: Array[Dictionary]

@onready var inventory: Inventory = preload("res://resources/inventory/default.tres")
@onready var Crops = $Crops

signal play_harvest_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	# convert pixel position to grid coord
	var grid_coord: Vector2i = Vector2i(int(pos.x / Global.TILE_SIZE), int(pos.y / Global.TILE_SIZE))
	match tool:
		Global.Tools.Hoe:
			$Tiles/Soil.set_cells_terrain_connect([grid_coord], 0, 0)
			hoedCoords.push_back(grid_coord)
		Global.Tools.Watering_Can:
			if (hoedCoords.has(grid_coord) == true):
				$Tiles/SoilWater.set_cells_terrain_connect([grid_coord], 0, 0)
				wateredCoords.push_back(grid_coord)
				if (cropCoords.has(grid_coord)):
					# set new crop watered
					# get crop scene
					var current_crop = currentCrops.filter(func(crop): return crop["coords"] == grid_coord)[0]
					if (current_crop):
						current_crop["crop_scene"].is_watered = true

func _on_player_plant_seed(crop: Item, pos: Vector2, slotIdx: int) -> void:
	# convert pixel position to grid coord
	var grid_coord: Vector2i = Vector2i(int(pos.x / Global.TILE_SIZE), int(pos.y / Global.TILE_SIZE))
	if (hoedCoords.has(grid_coord) == true and cropCoords.has(grid_coord) == false):
		cropCoords.push_back(grid_coord)
		var new_crop = crop_scene.instantiate()
		new_crop.harvest.connect(on_crop_harvested)
		new_crop.position = pos + Vector2(0, -4)
		new_crop.crop_type = crop
		Crops.add_child(new_crop)
		currentCrops.push_back({
			"crop_scene": new_crop,
			"coords": grid_coord
		})
		if (wateredCoords.has(grid_coord)):
			new_crop.is_watered = true
		inventory.remove(slotIdx)
		
func on_crop_harvested() -> void:
	play_harvest_animation.emit()
