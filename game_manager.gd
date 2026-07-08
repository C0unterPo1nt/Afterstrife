extends Node2D

enum States {selecting, character_acting}
var Character = load("res://character.tscn")

var game_board: Dictionary[Vector2i, Character] = {}
var state: States = States.selecting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("initialize_board")

func initialize_board():
	for actor in $Actors.get_children():
		var coordinates = $Helpers.absolute_to_grid_coordinates(actor.global_position)
		game_board.set(coordinates, actor)
		actor.grid_coordinates = coordinates
		actor.done.connect(_on_character_done)
		actor.moved.connect(_on_character_moved)
		actor.calculate_path.connect($NavGrid._on_calculate_path)
	$NavGrid.initialize_grid(game_board)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_click(_position):
	match state:
		States.selecting:
			var coordinates = $Helpers.absolute_to_grid_coordinates(_position)
			var character = game_board.get(coordinates)
			if character != null:
				character.activate()
				state = States.character_acting

func _on_character_done():
	state = States.selecting

func _on_character_moved(old_coordinates, new_coordinates):
	var character = game_board[old_coordinates]
	game_board.erase(old_coordinates)
	game_board.set(new_coordinates, character)
	$NavGrid.initialize_grid(game_board)
	pass
