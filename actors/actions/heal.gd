class_name Heal extends Action

func _init():
	name = "Heal"
	var potential_targets = TargetingConfig.TileMask.new(true, true, false, false, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	targeting_config = TargetingConfig.new(potential_targets, false, path_obstacles)

func predicate(character: Character) -> bool:
	var allies = Grid.get_allies_coordinates(character)
	var in_range = Grid.get_tiles_in_range(character.grid_coordinates, range)
	for ally in allies:
		var health_at_max = Grid.get_actor(ally).is_at_max_health()
		if !health_at_max && in_range.has(ally):
			return true
	return false

func act(character: Character, targeting: Node) -> void:
	var target_payload = await targeting.begin_targeting(character, range, targeting_config)
	var target = Grid.get_actor(target_payload[0])
	GameState.input_allowed = false
	await character.heal(target)
	GameState.input_allowed = true
