extends Node2D

var astar_grid:AStarGrid2D

func _ready():
	pass

func initialize_grid(game_board):
	astar_grid = AStarGrid2D.new()
	astar_grid.size = Grid.grid_size
	astar_grid.cell_size = Grid.cell_size
	astar_grid.offset = Vector2i.ZERO
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	for key in game_board.keys():
		astar_grid.set_point_solid(key, true)

func _on_calculate_path(start, end, callback, mask) -> void:
	for point in mask:
		if astar_grid.is_point_solid(point):
			astar_grid.set_point_solid(start, false)
		else:
			mask.erase(point)
	var path = astar_grid.get_point_path(start, end)
	callback.call(path)
	for point in mask:
			astar_grid.set_point_solid(start, true)
