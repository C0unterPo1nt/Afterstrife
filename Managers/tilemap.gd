extends TileMapLayer

var astar_grid:AStarGrid2D

enum Tile {Obstacle}

signal tile_selected(Vector2i)

func initialize():
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_size = Grid.cell_size
	reset()
	astar_grid.offset = Vector2i.ZERO
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

func reset():
	astar_grid.clear()
	astar_grid.region = Grid.region
	astar_grid.update()

func get_obstacles():
	var obstacles: Array[Vector2i]
	for pos in get_points():
		if get_cell_tile_data(pos).get_custom_data("Obstacle") == true:
			obstacles.append(pos)
	return obstacles

func get_points() -> Array[Vector2i]:
	var points: Array[Vector2i]
	for i in range(astar_grid.size.x):
		for j in range(astar_grid.size.y):
			points.append(Vector2i(i,j))
	return points

func set_blocked_by_obstacles():
	for obstacle in get_obstacles():
		astar_grid.set_point_solid(obstacle)

func calculate_path(start: Vector2i, end: Vector2i, unsolid_points: Array[Vector2i]) -> PackedVector2Array:
	reset()
	
	for point in get_points():
		if !unsolid_points.has(point):
			astar_grid.set_point_solid(point)
	
	astar_grid.set_point_solid(start, false)
	astar_grid.set_point_solid(end, false)

	var path = astar_grid.get_point_path(start, end)
	return path

func _on_input_click(_position) -> void:
	if GameState.input_allowed:
		var coordinates = Grid.absolute_to_grid_coordinates(_position)
		tile_selected.emit(coordinates)
