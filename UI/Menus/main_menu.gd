extends Control

var game = preload("res://game.tscn")

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _on_info_button_pressed() -> void:
	$TabContainer.current_tab = 1

func _on_back_button_pressed() -> void:
	$TabContainer.current_tab = 0
