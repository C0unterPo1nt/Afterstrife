class_name Move extends Action

func _init() -> void:
	name = "Move"
	var potential_targets = TargetingConfig.TileMask.new(true, false, false, false, true)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, true, true, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, true, path_obstacles)

func act_inner(character: Character, target_payload):
		var path: PackedVector2Array = target_payload[1]
		await character.move(path)
