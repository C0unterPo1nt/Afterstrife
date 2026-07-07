extends Node2D

var astar_grid = AStarGrid2D.new()
var grid_size

var start = Vector2i.ZERO

func _ready():
	initialize_grid()

func initialize_grid():
	grid_size = Vector2i(8, 4)
	astar_grid.size = grid_size
	astar_grid.cell_size = $Helpers.cell_size
	astar_grid.offset = Vector2i.ZERO
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()


func _on_click(coordinates) -> void:
	pass

func absolute_to_grid_coordinates(absolute_coordinates: Vector2):
	return Vector2i(absolute_coordinates) / $Helpers.cell_size


func _on_calculate_path(node, end) -> void:
	print('recieved', node, end)
	var coordinates_start = absolute_to_grid_coordinates(node.global_position)
	var coordinates_end = absolute_to_grid_coordinates(end)
	print('coordinates', coordinates_start, coordinates_end)
	var path = astar_grid.get_point_path(coordinates_start, coordinates_end)
	print('path', path)
	node.set_path(path)
	
