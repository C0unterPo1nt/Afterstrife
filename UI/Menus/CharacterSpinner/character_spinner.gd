extends HBoxContainer

@export var all_characters: Array[CharacterPreview]

func _init() -> void:
	call_deferred("init_characters")
	
func init_characters():
	for character in all_characters:
		var preview: TextureRect = TextureRect.new()
		preview.texture = character.preview_texture
		print(character)
		$CharacterContainer.add_child(preview)
