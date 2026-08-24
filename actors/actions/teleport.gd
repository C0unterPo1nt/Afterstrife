class_name Teleport extends Action

func _init() -> void:
	name = "Teleport"
	var potential_targets = TargetingConfig.TileMask.new(false, false, false, false, true)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, false, path_obstacles)

func act_inner(character: Character, target_payload):
		var path: PackedVector2Array = target_payload[1]
		await character.teleport(path[path.size() -1])
