@abstract class_name Action extends Resource

var name: String
var targeting_config: TargetingConfig


@abstract func predicate(character: Character) -> bool
