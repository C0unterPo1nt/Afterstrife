class_name Game extends Node2D

var team_configurations: Array[TeamConfiguration] = [TeamConfiguration.new(
	load("res://actors/teams/red_team.tres"),
	[
		preload("res://actors/characters/katana/katanagirl.tscn"),
		preload("res://actors/characters/witch/witch.tscn"),
		preload("res://actors/characters/witch/witch.tscn")
	]
), TeamConfiguration.new(
	load("res://actors/teams/blue_team.tres"),
	[
		preload("res://actors/characters/scythe/scythegirl.tscn"),
		preload("res://actors/characters/witch/witch.tscn"),
		preload("res://actors/characters/scythe/scythegirl.tscn")
	]
)]

var teams: Array[Team]
var map_path: String = "res://Map/Maps/base_map.tscn"
@onready var overlays = $UI/Overlays

func setup(team_configs: Array[TeamConfiguration], map_p: String):
	team_configurations = team_configs
	map_path = map_p

func _ready():
	$TileMap.create_instance(true, load(map_path))
	call_deferred("on_ready")

func on_ready():
	Grid.clear()
	for config in team_configurations:
		teams.append(config.team)
	$UI/GameMenu.init(teams)
	$Actors.init(team_configurations, $TileMap, $Targeting, $UI/ActionMenu)
	$Targeting.init($TileMap)
	$Turns.init(teams, overlays)
	start_game()

func start_game():
	$Turns.start()

func _process(delta: float) -> void:
	check_victory_condition()

func check_victory_condition():
	for team in teams:
		if team.defeated:
			teams.erase(team)
			game_over(teams[0])

func game_over(victor: Team):
	GameState.input_allowed = false
	overlays.show_victory_screen(victor)

func _on_return_to_menu_button_pressed() -> void:
	var main_menu = load("res://UI/Menus/main_menu.tscn")
	get_tree().change_scene_to_node(main_menu.instantiate())
	queue_free()
