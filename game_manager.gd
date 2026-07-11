extends Node2D

enum States {selecting, character_acting, between_turns}
var Character = load("res://character.tscn")

var game_board: Dictionary[Vector2i, Character] = {}
var state: States = States.between_turns
var turn_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("initialize_board")
	call_deferred("change_turn")

func initialize_board():
	for actor in $Actors.get_children():
		var coordinates = Grid.absolute_to_grid_coordinates(actor.global_position)
		game_board.set(coordinates, actor)
		actor.grid_coordinates = coordinates
		actor.done.connect(_on_character_done)
		actor.moved.connect(_on_character_moved)
		actor.calculate_path.connect($Tilemap._on_calculate_path)
		actor.update_preview_path.connect($MovementPreviewLine._on_update_path_preview)
		actor.update_state.connect($MovementPreviewLine._on_character_update_state)
	$Tilemap.initialize_grid(game_board)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_turn():
	state = States.selecting
	$Actors.refresh()

func change_turn():
	turn_count += 1
	$TurnCounter.text = "Turn {0}".format([turn_count])
	$TurnCounter.visible = true
	await get_tree().create_timer(2).timeout
	$TurnCounter.visible = false
	start_turn()

func _on_click(_position):
	match state:
		States.selecting:
			var coordinates = Grid.absolute_to_grid_coordinates(_position)
			var character = game_board.get(coordinates)
			if character != null && character.state == Constants.CharacterStates.ready:
				character.activate()
				state = States.character_acting

func _on_character_done():
	state = States.selecting

func _on_character_moved(old_coordinates, new_coordinates):
	var character = game_board[old_coordinates]
	game_board.erase(old_coordinates)
	game_board.set(new_coordinates, character)
	$Tilemap.initialize_grid(game_board)
	pass

func _on_end_turn_button_pressed():
	change_turn()
