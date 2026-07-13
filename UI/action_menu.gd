extends HBoxContainer

signal selected(action: Action)

func create(action: Action):
	var button = Button.new()
	button.text = action.name
	button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	button.pressed.connect(_on_button_pressed.bind(action))
	add_child(button)
	
func destroy():
	for button in get_children():
		button.queue_free()
	
func _on_button_pressed(action: Action):
	selected.emit(action)
