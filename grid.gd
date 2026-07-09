extends Node

var cell_size = Vector2i(32, 32)
var grid_size = Vector2i(8, 4)
var lower_bound = Vector2i.ZERO

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
