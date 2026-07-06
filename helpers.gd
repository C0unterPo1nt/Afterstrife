extends Node

func snap_to_grid(vector: Vector2):
	var vector_i = Vector2i(vector)
	return Vector2(vector_i - Vector2i((vector_i.x % 32), (vector_i.y % 32)))
