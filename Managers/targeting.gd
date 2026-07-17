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
	print(_tile_map)
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

func target_character(_character: Character) -> Character:
	mode = Modes.CHARACTER
	character = _character
	range = 1 #TODO placeholder
	activate()
	var target_character: Character
	while target_character == null:
		await tile_selected
		var target_coordinates = Grid.absolute_to_grid_coordinates(path[path.size() - 1])
		target_character = game_board.get(target_coordinates)
		print('selected', target_character, target_coordinates)
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
	print('nav mask', nav_mask)
	path = tile_map.calculate_path(character.grid_coordinates, reticle_coordinates, nav_mask)
	path = path.slice(0, range + 1)
	print('path', path)
	if mode == Modes.SPACE:
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
	#TODO: remove and implement a real targeting preview for attacks
	if mode == Modes.SPACE:
		$TargetPreviewIndicators.preview(Grid.absolute_to_grid_coordinates(character.global_position), range)
	visible(true)

func sleep():
	state = States.sleeping
	$TargetPreviewIndicators.clear()
	visible(false)
