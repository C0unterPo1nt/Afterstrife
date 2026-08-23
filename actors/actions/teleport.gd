class_name Teleport extends Action

func _init() -> void:
	name = "Teleport"
	var potential_targets = TargetingConfig.TileMask.new(false, false, false, false, true)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	targeting_config = TargetingConfig.new(potential_targets, false, path_obstacles)

func predicate(character: Character) -> bool:
	return true

func act(character: Character, targeting: Node) -> void:
		var target_payload = await targeting.begin_targeting(character, range, targeting_config)
		var path: PackedVector2Array = target_payload[1]
		GameState.input_allowed = false
		await character.teleport(path[path.size() -1])
		GameState.input_allowed = true
