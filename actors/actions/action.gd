@abstract class_name Action extends Resource

var name: String
var targeting_config: TargetingConfig
@export var range: int = 1

@abstract func predicate(character: Character) -> bool
@abstract func act(character: Character, targeting: Node) -> void
