extends HBoxContainer


func _on_start_game_button_pressed() -> void:
	#eventually get the map
	var team_configs: Array[TeamConfiguration] = [$TeamSetupContainer.get_team_configuration(), $TeamSetupContainer2.get_team_configuration()]
	var game: PackedScene = load("res://game.tscn")
	var instance = game.instantiate()
	instance.team_configurations = team_configs
	get_tree().change_scene_to_node(instance)
	pass
