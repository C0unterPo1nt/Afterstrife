class_name Teleport extends Action

func _init() -> void:
	name = "Teleport"
	var potential_targets = TargetingConfig.TileMask.new(false, false, false, false, true)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, false, path_obstacles)

func act(character: Character, targeting: Node) -> void:
		var target_payload = await targeting.begin_targeting(_potential_target_configs)
		var path: PackedVector2Array = target_payload[1]
		GameState.input_allowed = false
		await character.teleport(path[path.size() -1])
		GameState.input_allowed = true
