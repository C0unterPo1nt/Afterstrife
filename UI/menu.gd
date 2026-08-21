extends Control

func init(teams: Array[Team]):
	for team in teams:
		team.team_member_removed.connect(_on_team_member_loss)

func _on_team_member_loss(character: Character):
	var team = character.team
	if team == GameState.active_team:
		update_character_count(team)

func _process(delta) -> void:
	if GameState.input_allowed && !GameState.is_character_acting:
		$EndTurnButton.disabled = false
	else:
		$EndTurnButton.disabled = true

func update_character_count(team: Team):
	var count = team.actors.size()
	$TeamMemberCountLabel.text = "{0}/3".format([count])

func _on_turns_turn_changed(team: Team) -> void:
	$TeamNameLabel.text = team.name
	update_character_count(team)
