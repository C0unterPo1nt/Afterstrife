extends Node2D

var target_preview_indicator = load("res://Managers/targeting/target_preview_indicator.tscn")
signal target_selected(coords: Vector2i, path: PackedVector2Array)

func create_target_indicator(coords: Vector2i, path: PackedVector2Array, preview_path: bool):
		var indicator = target_preview_indicator.instantiate()
		indicator.init(path, coords, _on_target_preview_indicator_selected, preview_path)
		add_child(indicator)

func deactivate():
	for tile in get_children():
		tile.queue_free()

func _on_target_preview_indicator_selected(coords: Vector2i, path: PackedVector2Array):
	target_selected.emit(coords, path)
	deactivate()

# Legacy code
#region
var tile_sprite = load("res://sprites/PreviewSprites.png")
var sprite_region = Rect2(160,0,32,32)

func preview(tiles: Array[Vector2i]):
	for tile in tiles:
		instance_sprite(tile)

func instance_sprite(coords):
	var sprite = Sprite2D.new()
	sprite.global_position = Grid.grid_to_absolute_coordinates(coords) + Grid.cell_size/2
	sprite.texture = tile_sprite
	sprite.region_enabled = true
	sprite.region_rect = sprite_region
	sprite.modulate = Color(1,1,1,.3)
	add_child(sprite)
#endregion
