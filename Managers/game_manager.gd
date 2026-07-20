extends Node2D

@export var teams: Array[Team]

func _ready() -> void:
	call_deferred("initialize_game")
	call_deferred("change_turn")

func initialize_game():
	GameState.active_entity = self
	$Tilemap.initialize($CombatMenmapu, $Combat)
	$Tilemap/Actors.combat_menu = $CombatMenu
	$Turns.init(teams, $TurnCounter)
