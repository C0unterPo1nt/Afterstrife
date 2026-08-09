extends Control

@export var team: Team

func get_team_configuration() -> TeamConfiguration:
	var team_composition: Array[PackedScene] = []
	for child in get_children():
		if child is CharacterSpinner:
			team_composition.append(child.get_selected_character_scene())
	return TeamConfiguration.new(team, team_composition)
