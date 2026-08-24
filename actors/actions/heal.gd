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

func act_inner(character: Character, target_payload):
	var target = Grid.get_actor(target_payload[0])
	await character.heal(target)
