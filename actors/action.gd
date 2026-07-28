@abstract class_name Action

var name: String
var character: Character

@abstract func predicate() -> bool

class Move extends Action:
	func _init(character: Character):
		name = "Move"
	
	func predicate() -> bool:
		return true

class Attack extends Action:
	var range = 1
	func _init(_character: Character):
		name = "Attack"
		character = _character
	
	func predicate() -> bool:
		var tiles = Grid.find_squares_in_range(character.grid_coordinates, range)
		var characters: Array[Character] = Grid.get_actors(tiles).filter(func(x): return x != null)
		for other in characters:
			if other.team != character.team:
				return true
		return false
