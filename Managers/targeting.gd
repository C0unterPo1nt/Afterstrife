extends Node2D

enum States {targeting, sleeping}
enum Modes {SPACE, CHARACTER}

var state: States = States.sleeping
var mode: Modes
var character: Character
var path: PackedVector2Array
var tile_map: TileMapLayer
var game_board: Dictionary[Vector2i, Character]
var tile_selected: Signal
var range: int

func init(_game_board: Dictionary, _tile_map: TileMapLayer, _tile_selected: Signal):
	game_board = _game_board
	tile_map = _tile_map
	tile_selected = _tile_selected
	$TargetPreviewIndicators.tile_map = tile_map

func move(_character: Character) -> PackedVector2Array:
	mode = Modes.SPACE
	character = _character
	range = character.stats.movement
	activate()
	await tile_selected
	sleep()
	return path

func target_enemy(_character: Character, range: int):
	var valid_targets: Dictionary[Vector2i, Character] = {}
	for coords in game_board:
		var actor = game_board[coords]
		if actor.team != _character.team:
			valid_targets.set(coords, actor)
	return await target_character(_character, valid_targets, range)

func target_character(_character: Character, valid_targets: Dictionary[Vector2i, Character], range: int) -> Character:
	mode = Modes.CHARACTER
	character = _character
	activate(valid_targets.keys())
	var target_character: Character
	while target_character == null:
		await tile_selected
		if path.is_empty():
			continue
		var target_coordinates = Grid.absolute_to_grid_coordinates(path[path.size() - 1])
		if valid_targets.has(target_coordinates):
			target_character = game_board.get(target_coordinates)
	sleep()
	return target_character

func _process(delta: float) -> void:
	if state == States.targeting:
		var new_position = get_snapped_mouse_position()
		if new_position != $MovementReticleSprite.global_position:
			update_target(new_position)

func update_target(new_position: Vector2):
	var new_coordinates = Grid.absolute_to_grid_coordinates(new_position)
	$MovementReticleSprite.global_position = new_position
	var reticle_coordinates = Grid.absolute_to_grid_coordinates(new_position)
	var nav_mask: Array[Vector2i] = []
	if mode == Modes.CHARACTER && game_board.has(new_coordinates):
		nav_mask.append(new_coordinates)
	path = tile_map.calculate_path(character.grid_coordinates, reticle_coordinates, nav_mask)
	path = path.slice(0, range + 1)
	if mode == Modes.SPACE:
		$MovementPreviewLine.update_path_preview(path)

func get_snapped_mouse_position():
	return Grid.snap_to_grid(get_viewport().get_mouse_position())

func visible(is_visible):
	$MovementReticleSprite.visible = is_visible
	if mode == Modes.SPACE:
		$MovementPreviewLine.visible = is_visible

func activate(allowed_tiles: Array[Vector2i] = []):
	state = States.targeting
	update_target(get_snapped_mouse_position())
	var coords = Grid.absolute_to_grid_coordinates(character.global_position)
	if mode == Modes.SPACE:
		var tiles = Grid.find_squares_in_range(coords, range)
		$TargetPreviewIndicators.preview_paths(coords, range, tiles)
	if mode == Modes.CHARACTER:
		$TargetPreviewIndicators.preview_targets(coords, range, allowed_tiles)
	visible(true)

func sleep():
	state = States.sleeping
	$TargetPreviewIndicators.clear()
	visible(false)
