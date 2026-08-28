extends Control

@onready var portrait = $UnitCharacterContainer/CharacterPortraitContainer/CharacterPortrait

func init(character_preview: CharacterPreview) -> void:
	await ready
	portrait.texture = character_preview.preview_texture
	var profile = character_preview.profile
	$UnitCharacterContainer/CharacterProfileContainer/NameLabel.text = profile.name
	$UnitCharacterContainer/CharacterProfileContainer/DescriptionLabel.text = profile.description
	var likes = "Likes: " + profile.likes
	$UnitCharacterContainer/CharacterProfileContainer/LikesLabel.text = likes
	var dislikes = "Dislikes: " + profile.dislikes
	$UnitCharacterContainer/CharacterProfileContainer/DislikesLabel.text = dislikes
	var calling = "Lifes Calling: " + profile.calling
	$UnitCharacterContainer/CharacterProfileContainer/LifesCallingLabel.text = calling
	var weight = "Soul Wt.: " + profile.weight
	$UnitCharacterContainer/CharacterProfileContainer/SoulWeightLabel.text = weight
