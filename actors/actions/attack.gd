class_name Attack extends Action

func _init():
	name = "Attack"
	var potential_targets = TargetingConfig.TileMask.new(false, false, true, false, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, false, path_obstacles)

func act(character: Character, targeting: Node) -> void:
		var target_payload = await targeting.begin_targeting(_potential_target_configs)
		var target = Grid.get_actor(target_payload[0])
		GameState.input_allowed = false
		await character.attack(target)
		GameState.input_allowed = true
