extends HBoxContainer

var maps: Dictionary[String, String] = {
	"Cave": "res://Map/Maps/cave_map.tscn",
	"Docks": "res://Map/Maps/docks_map.tscn",
	"Graveyard": "res://Map/Maps/graveyard_map.tscn"
}

@onready var map_selector = $GameSettingsContainer/MapOptionButton

func _ready():
	for map in maps.keys():
		map_selector.add_item(map)

func init(characters: Array[CharacterPreview]):
	$TeamSetupContainer.init(characters)
	$TeamSetupContainer2.init(characters)

func _on_start_game_button_pressed() -> void:
	#eventually get the map
	var map: String = maps[map_selector.text]
	var team_configs: Array[TeamConfiguration] = [$TeamSetupContainer.get_team_configuration(), $TeamSetupContainer2.get_team_configuration()]
	var game: PackedScene = load("res://game.tscn")
	var instance = game.instantiate()
	instance.setup(team_configs, map)
	get_tree().change_scene_to_node(instance)
	pass
