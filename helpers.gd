extends Node

var cell_size = Vector2i(32, 32)

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
