class_name Attack extends Action

func _init():
	name = "Attack"
	var potential_targets = TargetingConfig.TileMask.new(false, false, true, false, false)
	var path_obstacles = TargetingConfig.TileMask.new(false, false, false, false, false)
	_targeting_config = TargetingConfig.new(targeting_predicate, potential_targets, false, path_obstacles)

func act_inner(character: Character, target_payload):
		var target = Grid.get_actor(target_payload[0])
		if target is not Character:
			return
		var animations = character.sprite_handler
		turn_towards_target(character, target)
		target.should_display_health(true)
		animations.attack()
		await animations.impact
		target.sprite_handler.damage()
		target.change_health(-character.stats.attack_strength)
		await target.sprite_handler.animation_finished
		target.should_display_health(false)
		if target.stats.health <= 0:
			target.die()
