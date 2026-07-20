extends TileMapLayer

var astar_grid:AStarGrid2D

enum Tile {Obstacle}

signal tile_selected(Vector2i)

var game_board: Dictionary[Vector2i, Character]

func initialize(menu: Control, combat: Node):
	game_board = $Actors.init(self, menu, $Targeting, $Movement, combat)
	initialize_astar_grid(game_board)
	$Targeting.init(game_board, self, tile_selected)

func initialize_astar_grid(game_board):
	astar_grid = AStarGrid2D.new()
	astar_grid.size = Grid.grid_size
	astar_grid.cell_size = Grid.cell_size
	astar_grid.offset = Vector2i.ZERO
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	for i in range(astar_grid.size.x):
		for j in range(astar_grid.size.y):
			var pos = Vector2i(i,j)
			if get_cell_tile_data(pos).get_custom_data("Obstacle") == true:
				astar_grid.set_point_solid(pos)
	for key in game_board.keys():
		astar_grid.set_point_solid(key, true)

func calculate_path(start: Vector2i, end: Vector2i, mask: Array[Vector2i] = []) -> PackedVector2Array:
	var start_previously_solid = astar_grid.is_point_solid(start)
	if start_previously_solid:
		astar_grid.set_point_solid(start, false)
	for point in mask:
		if astar_grid.is_point_solid(point):
			astar_grid.set_point_solid(point, false)
		else:
			mask.erase(point)
	var path = astar_grid.get_point_path(start, end)
	for point in mask:
			astar_grid.set_point_solid(point, true)
	if start_previously_solid:
		astar_grid.set_point_solid(start, true)
	return path

func _on_input_click(_position) -> void:
	if GameState.input_allowed:
		var coordinates = Grid.absolute_to_grid_coordinates(_position)
		tile_selected.emit(coordinates)
