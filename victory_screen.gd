extends Control

func show_victory_screen(victor: Team):
	$VictoryLabel.text = "{0} Wins!".format([victor.name])
	visible = true
