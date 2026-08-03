extends Node2D

enum States {targeting, sleeping}

var tile_map: TileMapLayer

func init(_tile_map: TileMapLayer):
	tile_map = _tile_map
	$PotentialTargets.tile_map = tile_map

func begin_targeting(config: TargetingConfig) -> Array:
	var reachable_tiles: Array[Vector2i] = Grid.get_tiles_in_range(config.character.grid_coordinates, config.range)
	#first remove blocking tiles from the array
	# TODO move to a helper
	if config.path_obstacles.obstacles:
		remove_entries(reachable_tiles, tile_map.get_obstacles())
	if config.path_obstacles.allies:
		var allies_coords = Grid.get_allies_coordinates(config.character)
		remove_entries(reachable_tiles, allies_coords)
	if config.path_obstacles.enemies:
		var enemies_coords = Grid.get_enemies_coordinates(config.character)
		remove_entries(reachable_tiles, enemies_coords)
	
	#then create targeting indicator passing selectable if its a valid target
	for tile in reachable_tiles:
		var path = tile_map.calculate_path(config.character.grid_coordinates, tile, reachable_tiles)
		if path.size() > config.range + 1 or path.is_empty():
			continue
		var character: Character = Grid.game_board.get(tile)
		var valid_target: bool = false
		if config.potential_targets.obstacles == true:
			if tile_map.get_cell_tile_data(tile).get_custom_data("Obstacle") == true:
				valid_target = true
		if character != null:
			if config.character.team == character.team && config.potential_targets.allies:
				valid_target = true
			if config.character.team != character.team && config.potential_targets.enemies:
				valid_target = true
		else:
			valid_target = true
		print('valid target', valid_target)
		$PotentialTargets.create_target_indicator(tile, path, valid_target)
	var target = await $PotentialTargets.target_selected
	return target

func remove_entries(original: Array, for_removal: Array):
	for i in for_removal:
		original.erase(i)

# Legacy implementation
# Logic will be moved out of here as it is deemed necessary
# TODO DELETE THIS
#region
enum Modes {SPACE, CHARACTER}
var mode: Modes
var path: PackedVector2Array
var tile_selected: Signal
var range: int
var state: States = States.sleeping

func move(_character: Character) -> PackedVector2Array:
	mode = Modes.SPACE
	activate()
	await tile_selected
	sleep()
	return path

func target_enemy(_character: Character, _range: int):
	var valid_targets: Dictionary[Vector2i, Character] = {}
	for coords in Grid.game_board:
		var actor = Grid.game_board[coords]
		if actor.team != _character.team:
			valid_targets.set(coords, actor)
	return await target_character(_character, valid_targets, _range)

func target_character(_character: Character, valid_targets: Dictionary[Vector2i, Character], _range: int) -> Character:
	range = _range
	mode = Modes.CHARACTER
	activate(valid_targets.keys())
	var target_character: Character
	while target_character == null:
		await tile_selected
		if path.is_empty():
			continue
		var target_coordinates = Grid.absolute_to_grid_coordinates(path[path.size() - 1])
		if valid_targets.has(target_coordinates):
			target_character = Grid.game_board.get(target_coordinates)
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
	if mode == Modes.CHARACTER && Grid.game_board.has(new_coordinates):
		nav_mask.append(new_coordinates)
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
	visible(true)

func sleep():
	state = States.sleeping
	$TargetPreviewIndicators.clear()
	visible(false)
#endregion
