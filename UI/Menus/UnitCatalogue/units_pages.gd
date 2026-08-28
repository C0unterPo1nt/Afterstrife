extends TabContainer

func  _ready() -> void:
	$UnitInfoContainer.queue_free()

func init(character_previews: Array[CharacterPreview]):
	var unit_info_page_scene = load("res://UI/Menus/UnitCatalogue/unit_info_page.tscn")
	for unit in character_previews:
		var page = unit_info_page_scene.instantiate()
		page.init(unit)
		add_child(page)

func _on_left_button_pressed() -> void:
	select_previous_available()

func _on_right_button_pressed() -> void:
	select_next_available()
