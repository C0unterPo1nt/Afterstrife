extends Control

var game = preload("res://game.tscn")

func _on_play_game_button_pressed() -> void:
	$TabContainer.current_tab = 2

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _on_info_button_pressed() -> void:
	$TabContainer.current_tab = 1

func _on_back_button_pressed() -> void:
	$TabContainer.current_tab = 0
