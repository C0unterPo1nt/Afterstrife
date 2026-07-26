extends Node

var cell_size = Vector2i(32, 32)
var grid_size = Vector2i(16, 8)
var lower_bound = Vector2i.ZERO
var game_board: Dictionary[Vector2i, Character]

func get_actor(coords: Vector2i):
	return game_board.get(coords)

func get_actors(coords: Array[Vector2i]):
	var actors: Array[Character] = []
	for i in coords:
		actors.append(game_board.get(i))
	return actors

func snap_to_grid(vector: Vector2):
	var vector_i = Vector2i(vector)
	return Vector2(vector_i - Vector2i((vector_i.x % cell_size.x), (vector_i.y % cell_size.y)))

func vector_int_comparison(vector_1: Vector2, vector_2: Vector2):
	return Vector2i(vector_1) == Vector2i(vector_2)

func project_to_nearest_cardinal(vector: Vector2):
	if abs(vector.x) > abs(vector.y):
		return vector.project(Vector2(1,0))
	else:
		return vector.project(Vector2(0,1))

func absolute_to_grid_coordinates(absolute_coordinates: Vector2):
	var snapped = snap_to_grid(absolute_coordinates)
	return Vector2i(snapped) / cell_size

func grid_to_absolute_coordinates(grid_coordinates: Vector2i):
	return grid_coordinates * cell_size

func find_squares_in_range(origin: Vector2i, range: int):
	var tiles: Array[Vector2i] = []
	for ring in range(range + 1):
		for i in range(ring):
			tiles.append(Vector2i(i, ring-i) + origin)
			tiles.append(Vector2i(ring-i, -i) + origin)
			tiles.append(Vector2i(-i, -ring+i) + origin)
			tiles.append(Vector2i(-ring+i, i) + origin)
	return tiles
	
