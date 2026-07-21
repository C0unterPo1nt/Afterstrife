extends Node2D

@export var teams: Array[Team]

func _ready() -> void:
	call_deferred("initialize_game")
	call_deferred("change_turn")

func _process(delta: float) -> void:
	check_victory_condition()

func initialize_game():
	GameState.active_entity = self
	$Tilemap.initialize($CombatMenu, $Combat)
	$Tilemap/Actors.combat_menu = $CombatMenu
	$Turns.init(teams, $Label)

func check_victory_condition():
	for team in teams:
		if team.defeated:
			teams.erase(team)
			game_over(teams[0])

func game_over(victor: Team):
	GameState.input_allowed = false
	$Label.text = "{0} Wins!".format([victor.name])
	$Label.visible = true
