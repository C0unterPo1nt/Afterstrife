extends TabContainer

func _on_right_button_pressed() -> void:
	var changed = select_next_available()
	if not changed:
		current_tab = 0


func _on_left_button_pressed() -> void:
	var changed = select_previous_available()
	if not changed:
		current_tab = get_tab_count() - 1
