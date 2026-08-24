class_name PotentialTargetConfig

var coordinates: Vector2i
var path: PackedVector2Array
var preview_path: bool

func _init(_coordinates: Vector2i, _path: PackedVector2Array, _preview_path: bool) -> void:
	coordinates = _coordinates
	path = _path
	preview_path = _preview_path
