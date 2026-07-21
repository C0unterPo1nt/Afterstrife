extends Node2D

var tile_sprite = load("res://sprites/PreviewSprites.png")
var tile_map: TileMapLayer
var sprite_region = Rect2(160,0,32,32)



func clear():
	for node in get_children():
		node.queue_free()

func preview_targets(origin: Vector2i, range: int, allowed_tiles: Array[Vector2i]):
	_preview(origin, range, allowed_tiles, allowed_tiles)

func preview_paths(origin: Vector2i, range: int):
	# make a set of coordinates that are range or less away
	var within_radius: Array[Vector2i]
	for x in range(origin.x - range, origin.x + range):
		for y in range(origin.y - range, origin.y + range):
			var point = Vector2i(x,y)
			if point.distance_to(origin) < range:
				within_radius.append(point)
	_preview(origin, range, within_radius)

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

func instance_sprite(coords):
	var sprite = Sprite2D.new()
	sprite.global_position = Grid.grid_to_absolute_coordinates(coords) + Grid.cell_size/2
	sprite.texture = tile_sprite
	sprite.region_enabled = true
	sprite.region_rect = sprite_region
	sprite.modulate = Color(1,1,1,.3)
	add_child(sprite)
