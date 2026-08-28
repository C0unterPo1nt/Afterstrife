extends Control

@onready var portrait = $UnitCharacterContainer/CharacterPortraitContainer/CharacterPortrait

func init(character_preview: CharacterPreview) -> void:
	await ready
	portrait.texture = character_preview.preview_texture
	var profile = character_preview.profile
	var stats = character_preview.stats
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
	var health = "Health: " + str(stats.max_health)
	$UnitStatsContainer/BasicStatsContainer/HealthLabel.text = health
	var action_count = "Actions/Turn: " + str(stats.maximum_actions)
	$UnitStatsContainer/BasicStatsContainer/ActionsLabel.text = action_count
	var action_container_scene = load("res://UI/Menus/UnitCatalogue/action_info.tscn")
	for action in stats.actions:
		var container = action_container_scene.instantiate()
		container.init(action)
		$UnitStatsContainer.add_child(container)
