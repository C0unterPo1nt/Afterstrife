extends BoxContainer

signal selected(action: Action)

func _ready() -> void:
	destroy()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		selected.emit(null)

func make_action_selection(character: Character) -> Action:
	var actions: Array[Action] = character.stats.actions
	offset_if_needed(character)
	show()
	for action in actions:
		if action.predicate(character):
			create(action)
	var selected_action: Action = await selected
	destroy()
	hide()
	return selected_action

func offset_if_needed(character: Character):
	var unit = float(Grid.cell_size.x)
	if character.grid_coordinates.x > Grid.grid_size.x - 3:
		position.x = -size.x
	else:
		position.x = unit
	if character.grid_coordinates.y > Grid.grid_size.y - 2:
		position.y = -2 * unit
		alignment = ALIGNMENT_END
	elif character.grid_coordinates.y == 0:
		position.y = 0
		alignment = ALIGNMENT_BEGIN
	else:
		position.y = -unit
		alignment = ALIGNMENT_CENTER
	

func create(action: Action):
	var button = Button.new()
	button.text = action.name
	button.add_theme_font_size_override("font_size", 9)
	button.pressed.connect(_on_button_pressed.bind(action))
	add_child(button)

func destroy():
	for button in get_children():
		button.queue_free()

func _on_button_pressed(action: Action):
	selected.emit(action)
