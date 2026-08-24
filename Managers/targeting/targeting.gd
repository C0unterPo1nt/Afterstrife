class_name Targeting extends Node2D

enum States {targeting, sleeping}

var tile_map: Node2D

func init(_tile_map: Node2D):
	tile_map = _tile_map

func calculate_valid_targets(character: Character, range: int, config: TargetingConfig) -> Array[PotentialTargetConfig]:
	var reachable_tiles: Array[Vector2i] = get_navigable_tiles_in_range(character, range, config)
	var potential_target_configs: Array[PotentialTargetConfig] = []
	for tile in reachable_tiles:
		var path = tile_map.calculate_path(character.grid_coordinates, tile, reachable_tiles)
		var potential_target_config = PotentialTargetConfig.new(tile, path, config.preview_path)
		if path.size() > range + 1 or path.is_empty():
			continue
		var character_at_tile: Character = Grid.game_board.get(tile)
		if tile_map.get_map_tile_data(tile).get_custom_data("Obstacle") == true:
			if config.potential_targets.obstacles == true && config.predicate.call(potential_target_config):
				potential_target_configs.append(potential_target_config)
		elif character_at_tile != null:
			if character.team == character_at_tile.team && config.potential_targets.allies && config.predicate.call(potential_target_config):
				potential_target_configs.append(potential_target_config)
			elif character.team != character_at_tile.team && config.potential_targets.enemies && config.predicate.call(potential_target_config):
				potential_target_configs.append(potential_target_config)
		elif config.potential_targets.empty_tiles && config.predicate.call(potential_target_config):
				potential_target_configs.append(potential_target_config)
	return potential_target_configs

func begin_targeting(potential_target_configs: Array[PotentialTargetConfig]) -> Array:
	for config in potential_target_configs:
		$PotentialTargets.create_target_indicator(config.coordinates, config.path, config.preview_path)
	
	var target = await $PotentialTargets.target_selected
	return target

func get_navigable_tiles_in_range(character: Character, range: int, config: TargetingConfig):
	var reachable_tiles: Array[Vector2i] = Grid.get_tiles_in_range(character.grid_coordinates, range)
	if config.path_obstacles.obstacles:
		remove_entries(reachable_tiles, tile_map.get_obstacles())
	if config.path_obstacles.allies:
		var allies_coords = Grid.get_allies_coordinates(character)
		remove_entries(reachable_tiles, allies_coords)
	if config.path_obstacles.enemies:
		var enemies_coords = Grid.get_enemies_coordinates(character)
		remove_entries(reachable_tiles, enemies_coords)
	return reachable_tiles

func remove_entries(original: Array, for_removal: Array):
	for i in for_removal:
		original.erase(i)
