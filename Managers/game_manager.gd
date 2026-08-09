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

func _ready():
	call_deferred("on_ready")

func on_ready():
	for config in team_configurations:
		teams.append(config.team)
	$Actors.init(team_configurations, $TileMap, $UI/CombatMenu, $Targeting, $Combat)
	$Targeting.init($TileMap)
	$Turns.init(teams, $UI/Label)
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
	$UI/Label.text = "{0} Wins!".format([victor.name])
	$UI/Label.visible = true
