extends Node2D

var target_preview_indicator = load("res://Managers/targeting/target_preview_indicator.tscn")
signal target_selected(coords: Vector2i, path: PackedVector2Array)

func create_target_indicator(coords: Vector2i, path: PackedVector2Array, selectable: bool, preview_path: bool):
		var indicator = target_preview_indicator.instantiate()
		indicator.init(path, coords, _on_target_preview_indicator_selected, selectable, preview_path)
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
var tile_map: TileMapLayer
var sprite_region = Rect2(160,0,32,32)

func clear():
	for node in get_children():
		node.queue_free()

func preview_targets(origin: Vector2i, range: int, allowed_tiles: Array[Vector2i]):
	_preview(origin, range, allowed_tiles, allowed_tiles)

func preview_paths(origin: Vector2i, range: int):
	var tiles = Grid.get_tiles_in_range(origin, range)
	_preview(origin, range, tiles)

func _preview(origin: Vector2i, range: int, allowed_tiles: Array[Vector2i] = [], tile_override: Array[Vector2i] = []):
	# for every tile in set
	for tile in allowed_tiles:
	# call tilemap for a path
		var path_mask: Array[Vector2i] = tile_override
		var path = tile_map.calculate_path(origin, tile, path_mask)
	# if path.size is less than or equal to range + 1, save
		if path.is_empty():
			continue
		if path.size() <= range + 1:
			instance_sprite(tile)
	# each saved coordinates gets a sprite

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
