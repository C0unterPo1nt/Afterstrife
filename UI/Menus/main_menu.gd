extends Control

func _on_start_game_button_pressed() -> void:
	#TODO
	print("start")



func _on_quit_game_button_pressed() -> void:
	#TODO
	print("quit")


func _on_info_button_pressed() -> void:
	$TabContainer.current_tab = 1


func _on_back_button_pressed() -> void:
	$TabContainer.current_tab = 0
