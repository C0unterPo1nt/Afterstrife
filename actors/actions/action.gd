@abstract class_name Action extends Resource

var name: String
@export var range: int
var _targeting_config: TargetingConfig
var _potential_target_configs: Array[PotentialTargetConfig]

func predicate(character: Character) -> bool:
	_potential_target_configs = character.targeting.calculate_valid_targets(character, range, _targeting_config)
	return _potential_target_configs.size() > 0

func targeting_predicate(config: PotentialTargetConfig) -> bool:
	return true

func act(character: Character, targeting: Node) -> bool:
	var target_payload = await targeting.begin_targeting(_potential_target_configs)
	if target_payload[0] == null:
		return false
	GameState.input_allowed = false
	await act_inner(character, target_payload)
	GameState.input_allowed = true
	return true

@abstract func act_inner(character: Character, target_payload: Array)

func turn_towards_target(character: Character, target: Character):
	var animations = character.sprite_handler
	if target.grid_coordinates.x < character.grid_coordinates.x:
		animations.flip_h = true
	elif target.grid_coordinates.x > character.grid_coordinates.x:
		animations.flip_h = false
