class_name Heal extends Action

func _init():
	name = "Heal"
	var potential_targets = TargetingConfig.TileMask.new(true, true, false, false, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, false, path_obstacles)

func targeting_predicate(config: PotentialTargetConfig):
	var character: Character = Grid.get_actor(config.coordinates)
	if !character.is_at_max_health():
		return true
	return false

func act(character: Character, targeting: Node) -> void:
	var target_payload = await targeting.begin_targeting(_potential_target_configs)
	var target = Grid.get_actor(target_payload[0])
	GameState.input_allowed = false
	await character.heal(target)
	GameState.input_allowed = true
