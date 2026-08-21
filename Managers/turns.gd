extends Node

var team_queue: Array[Team]
var turn_count: int = 0
var round_count: int = 1
var overlays: Control

signal turn_changed(team: Team)

func init(_team_queue, _overlays: Control):
	team_queue = _team_queue
	overlays = _overlays

func start():
	start_turn(team_queue[turn_count])

func start_turn(team):
	turn_changed.emit(team)
	await overlays.show_prompt(team, round_count)
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


	

func next_round():
	turn_count = 0
	round_count +=1
	start_turn(team_queue[turn_count])
	

func _on_end_turn_button_pressed():
	if GameState.input_allowed:
		next_turn()
