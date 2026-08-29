class_name CharacterSpinner extends CenterContainer

var all_characters: Array[CharacterPreview]
	
func init_characters(_all_characters: Array[CharacterPreview]):
	all_characters = _all_characters
	for character in all_characters:
		var preview: TextureRect = TextureRect.new()
		preview.texture = character.preview_texture
		$HLayout/CharacterContainer.add_child(preview)

func get_selected_character_scene():
	return all_characters[$HLayout/CharacterContainer.current_tab].scene
