extends TabContainer

signal done

func _ready() -> void:
	for page in get_children():
		page.done.connect(_on_page_done)
	get_current_tab_control().start()

func _on_page_done():
	if current_tab == get_tab_count() -1:
		end()
	else:
		current_tab += 1
		get_current_tab_control().start()

func end():
	done.emit()
