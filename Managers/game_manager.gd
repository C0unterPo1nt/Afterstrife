extends Node2D

@export var teams: Array[Team]

func _ready() -> void:
	call_deferred("initialize_game")
	call_deferred("change_turn")

func _process(delta: float) -> void:
	check_victory_condition()

func initialize_game():
	GameState.active_entity = self
	$Tilemap.initialize()
	$Actors.init($Tilemap, $UI/CombatMenu, $Targeting, $Combat)
	$Turns.init(teams, $UI/Label)
	$Targeting.init($Tilemap)

func check_victory_condition():
	for team in teams:
		if team.defeated:
			teams.erase(team)
			game_over(teams[0])

func game_over(victor: Team):
	GameState.input_allowed = false
	$UI/Label.text = "{0} Wins!".format([victor.name])
	$UI/Label.visible = true
