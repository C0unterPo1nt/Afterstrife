class_name Attack extends Action

func _init():
	name = "Attack"
	var potential_targets = TargetingConfig.TileMask.new(false, false, true, false, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, false, path_obstacles)

func act_inner(character: Character, target_payload):
		var target = Grid.get_actor(target_payload[0])
		await character.attack(target)
