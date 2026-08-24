extends Node2D

signal selected(coords: Vector2i, path: PackedVector2Array)
var _path: PackedVector2Array
var _coords: Vector2i
var _preview_path: bool

func init(path: PackedVector2Array, coords: Vector2i, callback: Callable, preview_path: bool):
	position = Grid.grid_to_absolute_coordinates(coords)
	_path = path
	_coords = coords
	_preview_path = preview_path
	selected.connect(callback)
	$MovementPreviewLine.update_path_preview(position, _path)

func _process(delta: float) -> void:
	if GameState.input_allowed:
		if Grid.absolute_to_grid_coordinates(get_viewport().get_mouse_position()) == _coords:
			$Reticle.visible = true
			if _preview_path:
				$MovementPreviewLine.visible = true
		else:
			$Reticle.visible = false
			if _preview_path:
				$MovementPreviewLine.visible = false

func _input(event: InputEvent) -> void:
	var is_mouse_over_self = Grid.absolute_to_grid_coordinates(get_viewport().get_mouse_position()) == _coords
	var clicked = event is InputEventMouseButton && event.pressed
	if clicked && is_mouse_over_self:
		selected.emit(_coords, _path)
