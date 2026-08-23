class_name Attack extends Action

func _init():
	name = "Attack"
	var potential_targets = TargetingConfig.TileMask.new(false, false, true, false, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	targeting_config = TargetingConfig.new(potential_targets, false, path_obstacles)

func predicate(character: Character) -> bool:
	var tiles = Grid.get_tiles_in_range(character.grid_coordinates, range)
	var characters: Array[Character] = Grid.get_actors(tiles).filter(func(x): return x != null)
	for other in characters:
		if other.team != character.team:
			return true
	return false

func act(character: Character, targeting: Node) -> void:
		var target_payload = await targeting.begin_targeting(character, range, targeting_config)
		var target = Grid.get_actor(target_payload[0])
		GameState.input_allowed = false
		await character.attack(target)
		GameState.input_allowed = true
