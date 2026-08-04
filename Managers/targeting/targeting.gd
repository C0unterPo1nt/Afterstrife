extends Node2D

enum States {targeting, sleeping}

var tile_map: TileMapLayer

func init(_tile_map: TileMapLayer):
	tile_map = _tile_map
	$PotentialTargets.tile_map = tile_map

func begin_targeting(config: TargetingConfig) -> Array:
	var reachable_tiles: Array[Vector2i] = get_navigable_tiles_in_range(config)
	
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
		$PotentialTargets.create_target_indicator(tile, path, valid_target, config.preview_path)
	
	var target = await $PotentialTargets.target_selected
	return target

func get_navigable_tiles_in_range(config):
	var reachable_tiles: Array[Vector2i] = Grid.get_tiles_in_range(config.character.grid_coordinates, config.range)
	if config.path_obstacles.obstacles:
		remove_entries(reachable_tiles, tile_map.get_obstacles())
	if config.path_obstacles.allies:
		var allies_coords = Grid.get_allies_coordinates(config.character)
		remove_entries(reachable_tiles, allies_coords)
	if config.path_obstacles.enemies:
		var enemies_coords = Grid.get_enemies_coordinates(config.character)
		remove_entries(reachable_tiles, enemies_coords)
	return reachable_tiles

func remove_entries(original: Array, for_removal: Array):
	for i in for_removal:
		original.erase(i)
