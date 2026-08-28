class_name CharacterSpinner extends CenterContainer

var all_characters: Array[CharacterPreview]

func _init() -> void:
	call_deferred("init_characters")
	
func init_characters():
	for character in all_characters:
		var preview: TextureRect = TextureRect.new()
		preview.texture = character.preview_texture
		$HLayout/CharacterContainer.add_child(preview)

func get_selected_character_scene():
	return all_characters[$HLayout/CharacterContainer.current_tab].scene
