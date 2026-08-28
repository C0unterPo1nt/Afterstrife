extends Control

@export var team: Team

func get_team_configuration() -> TeamConfiguration:
	var team_composition: Array[PackedScene] = []
	for child in get_spinners():
		team_composition.append(child.get_selected_character_scene())
	return TeamConfiguration.new(team, team_composition)

func get_spinners():
	var spinners: Array = []
	for child in get_children():
		if child is CharacterSpinner:
			spinners.append(child)
	return spinners

func init(characters: Array):
	for spinner in get_spinners():
		spinner.all_characters = characters

func _ready() -> void:
	$TeamNameLabel.text = team.name
