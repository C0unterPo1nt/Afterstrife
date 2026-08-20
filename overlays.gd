extends Control

func show_victory_screen(victor: Team):
	$VictoryScreen/VictoryLabel.text = "{0} Wins!".format([victor.name])
	$VictoryScreen.show()
	$BackgroundGradientTexture.show()

func show_prompt(team: Team, round_count: int):
	GameState.input_allowed = false
	var prompt = $ChangeTurnPrompt
	$BackgroundGradientTexture.show()
	prompt.get_node("TurnCountLabel").text = "Turn {0}".format([round_count])
	prompt.get_node("TeamNameLabel").text = team.name
	prompt.show()
	await prompt.get_node("StartTurnButton").pressed
	prompt.hide()
	$BackgroundGradientTexture.hide()
	GameState.input_allowed = true
