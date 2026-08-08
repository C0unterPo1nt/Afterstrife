extends Node2D

var combat_menu: Control
var targeting: Node
var tilemap: Node2D
var combat: Node
var is_character_acting: bool = false

@export var team_configurations: Array[TeamConfiguration]

func init(_tilemap: Node2D, _combat_menu: Control, _targeting: Node, _combat: Node):
	combat_menu = _combat_menu
	targeting = _targeting
	tilemap = _tilemap
	combat = _combat
	for config in team_configurations:
		var team = config.team
		var starting_positions: Array[Vector2] = tilemap.get_starting_positions_for_team(team)
		for char in config.members:
			if starting_positions.is_empty():
				break
			var character = char.instantiate()
			add_child(character)
			character.position = Grid.snap_to_grid(starting_positions.pop_front())
			var coordinates = Grid.absolute_to_grid_coordinates(character.position)
			Grid.game_board.set(coordinates, character)
			character.init(coordinates, team)

func sleep():
	for actor in get_children():
		actor.sleep()

func character_act(character: Character):
	is_character_acting = true
	var action: Action = await combat_menu.make_action_selection(character)
	
	if action is Move:
		var target_payload = await targeting.begin_targeting(character, action.movement, action.targeting_config)
		var path: PackedVector2Array = target_payload[1]
		GameState.input_allowed = false
		await character.move(path)
		var final_coords = Grid.absolute_to_grid_coordinates(path[path.size()-1])
		Grid.game_board.erase(character.grid_coordinates)
		Grid.game_board.set(final_coords, character)
		character.grid_coordinates = final_coords
		GameState.input_allowed = true
	elif action is Attack:
		var target_payload = await targeting.begin_targeting(character, action.range, action.targeting_config)
		var target = Grid.get_actor(target_payload[0])
		GameState.input_allowed = false
		await combat.initiate(character, target)
		GameState.input_allowed = true
		
	character.deactivate()
	is_character_acting = false
	

func _on_input_click(_position) -> void:
	if GameState.input_allowed && !is_character_acting:
		var coordinates = Grid.absolute_to_grid_coordinates(_position)
		var character = Grid.get_actor(coordinates)
		if character == null:
			return
		if character.state != Character.States.ready:
			return
		if character.team != GameState.active_team:
			return
		character.activate()
		await character_act(character)
