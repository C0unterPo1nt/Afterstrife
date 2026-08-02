extends Node2D

signal selected(coords: Vector2i, path: PackedVector2Array)
var _path: PackedVector2Array
var _coords: Vector2i
var _selectable: bool

func init(path: PackedVector2Array, coords: Vector2i, callback: Callable, selectable: bool):
	position = Grid.grid_to_absolute_coordinates(coords)
	_path = path
	_coords = coords
	_selectable = selectable
	selected.connect(callback)

func _input(event: InputEvent) -> void:
	var is_mouse_over_self = Grid.absolute_to_grid_coordinates(get_viewport().get_mouse_position()) == _coords
	var clicked = event is InputEventMouseButton && event.pressed
	if clicked && is_mouse_over_self && _selectable:
		selected.emit(_coords, _path)
