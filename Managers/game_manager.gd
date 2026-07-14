extends Node2D

enum States {selecting, character_acting, between_turns}

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
	$Tilemap.initialize_grid(game_board)
	$Targeting.init(game_board, $Tilemap)
	

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
	await get_tree().create_timer(1).timeout
	$TurnCounter.visible = false
	start_turn()

func character_act(character: Character):
	state = States.character_acting
	var action: Action = await $Menu.make_action_selection(character.actions)
	for sub in action.sequence:
		await perform_sub_act(character, sub)
	character.remaining_actions = character.remaining_actions - 1
	state = States.selecting

func perform_sub_act(character: Character, sub: SubAction):
	if sub is SubAction.Move:
		var path: PackedVector2Array = await $Targeting.move(character)
		await $Movement.move(character, path)
		var final_coords = Grid.absolute_to_grid_coordinates(path[path.size()-1])
		game_board.erase(character.grid_coordinates)
		game_board.set(final_coords, character)
		character.grid_coordinates = final_coords
		$Tilemap.initialize_grid(game_board)
	elif sub is SubAction.Attack:
		var target = await $Targeting.target_character(character)
		$Combat.initiate(character, target)
	

func _on_end_turn_button_pressed():
	change_turn()

func _on_input_click(_position) -> void:
	match state:
		States.selecting:
			var coordinates = Grid.absolute_to_grid_coordinates(_position)
			var character = game_board.get(coordinates)
			if character != null && character.state == Character.States.ready:
				var action = Action.Move.new()
				character_act(character)
