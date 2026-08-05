class_name Attack extends Action

@export var range = 1

func _init():
	name = "Attack"
	var potential_targets = TargetingConfig.TileMask.new(false, false, true, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false)
	targeting_config = TargetingConfig.new(potential_targets, false, path_obstacles)

func predicate(character: Character) -> bool:
	var tiles = Grid.get_tiles_in_range(character.grid_coordinates, range)
	var characters: Array[Character] = Grid.get_actors(tiles).filter(func(x): return x != null)
	for other in characters:
		if other.team != character.team:
			return true
	return false
