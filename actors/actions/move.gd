class_name Move extends Action

@export var movement: int

func _init() -> void:
	name = "Move"
	var potential_targets = TargetingConfig.TileMask.new(false, false, false, true)
	var path_obstacles = TargetingConfig.TileMask.new(true, false, true, false)
	targeting_config = TargetingConfig.new(potential_targets, true, path_obstacles)

func predicate(character: Character) -> bool:
	return true
