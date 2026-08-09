extends Node

var team_queue: Array[Team]
var turn_count: int = 0
var round_count: int = 1
var turn_counter_ui: Control

func init(_team_queue, _turn_counter_ui: Control):
	team_queue = _team_queue
	turn_counter_ui = _turn_counter_ui

func start():
	start_turn(team_queue[turn_count])

func start_turn(team):
	await show_turn_label(team)
	GameState.active_team = team
	team.refresh()
	GameState.input_allowed = true

func end_turn(team):
	GameState.input_allowed = false
	for actor in team_queue[turn_count].actors:
		actor.sleep()

func next_turn():
	end_turn(team_queue[turn_count])
	turn_count += 1
	if turn_count < team_queue.size():
		start_turn(team_queue[turn_count])
	else:
		next_round()

func show_turn_label(team: Team):
	GameState.input_allowed = false
	turn_counter_ui.text = "{0} Turn {1}".format([team.name, round_count])
	turn_counter_ui.visible = true
	await get_tree().create_timer(1).timeout
	turn_counter_ui.visible = false
	GameState.input_allowed = true
	

func next_round():
	turn_count = 0
	round_count +=1
	start_turn(team_queue[turn_count])
	

func _on_end_turn_button_pressed():
	if GameState.input_allowed:
		next_turn()
