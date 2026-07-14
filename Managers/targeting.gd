extends Node2D

enum States {targeting, sleeping}
enum Modes {SPACE, CHARACTER}

var state: States = States.sleeping
var mode: Modes
var character: Character
var path: PackedVector2Array
var target_coordinates: Vector2i
var tilemap: TileMapLayer
var game_board: Dictionary[Vector2i, Character]

signal selected

func init(_game_board: Dictionary, _tilemap: TileMapLayer):
	game_board = _game_board
	tilemap = _tilemap
	print(game_board)

func move(_character: Character) -> PackedVector2Array:
	mode = Modes.SPACE
	character = _character
	activate()
	await selected
	sleep()
	return path

func target_character(_character: Character) -> Character:
	mode = Modes.CHARACTER
	character = _character
	activate()
	await selected
	sleep()
	var target_character = game_board.get(target_coordinates)
	return target_character

func _process(delta: float) -> void:
	if state == States.targeting:
		var new_position = get_snapped_mouse_position()
		if new_position != $MovementReticleSprite.global_position:
			update_target(new_position)

func update_target(new_position: Vector2):
	target_coordinates = Grid.absolute_to_grid_coordinates(new_position)
	$MovementReticleSprite.global_position = new_position
	if mode == Modes.SPACE:
		path = tilemap.calculate_path(character.grid_coordinates, target_coordinates, [character.grid_coordinates])
		$MovementPreviewLine.update_path_preview(path)

func get_snapped_mouse_position():
	return Grid.snap_to_grid(get_viewport().get_camera_2d().get_global_mouse_position())

func visible(is_visible):
	$MovementReticleSprite.visible = is_visible
	if mode == Modes.SPACE:
		$MovementPreviewLine.visible = is_visible

func activate():
	state = States.targeting
	update_target(get_snapped_mouse_position())
	visible(true)

func sleep():
	state = States.sleeping
	visible(false)

func _on_input_click(_position) -> void:
	selected.emit()
