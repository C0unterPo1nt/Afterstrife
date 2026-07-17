extends Node2D

enum States {selecting, character_acting, between_turns}

var state: States = States.between_turns
var turn_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("initialize_game")
	call_deferred("change_turn")

func initialize_game():
	$Tilemap.initialize($CombatMenu, $Combat)
	$Tilemap/Actors.combat_menu = $CombatMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_turn():
	state = States.selecting
	$"Tilemap/Actors".refresh()

func change_turn():
	turn_count += 1
	$TurnCounter.text = "Turn {0}".format([turn_count])
	$TurnCounter.visible = true
	await get_tree().create_timer(1).timeout
	$TurnCounter.visible = false
	start_turn()
	

func _on_end_turn_button_pressed():
	if state == States.selecting:
		change_turn()
