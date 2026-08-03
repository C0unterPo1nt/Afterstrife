@abstract class_name Action

var name: String
var character: Character
var targeting_config: TargetingConfig

@abstract func predicate() -> bool

class Move extends Action:
	func _init(character: Character):
		name = "Move"
		var potential_targets = TargetingConfig.TileMask.new(false, false, false, true)
		var path_obstacles = TargetingConfig.TileMask.new(true, false, true, false)
		targeting_config = TargetingConfig.new(potential_targets, character.stats.movement, character, true, path_obstacles)
	
	func predicate() -> bool:
		return true

class Attack extends Action:
	var range = 1
	func _init(_character: Character):
		name = "Attack"
		character = _character
		var potential_targets = TargetingConfig.TileMask.new(false, false, true, false)
		var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false)
		targeting_config = TargetingConfig.new(potential_targets, range, character, true, path_obstacles)
	
	func predicate() -> bool:
		var tiles = Grid.get_tiles_in_range(character.grid_coordinates, range)
		var characters: Array[Character] = Grid.get_actors(tiles).filter(func(x): return x != null)
		for other in characters:
			if other.team != character.team:
				return true
		return false
