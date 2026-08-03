extends Node2D

var combat_menu: Control
var targeting: Node
var tilemap: TileMapLayer
var combat: Node
var is_character_acting: bool = false

func init(_tilemap: TileMapLayer, _combat_menu: Control, _targeting: Node, _combat: Node):
	combat_menu = _combat_menu
	targeting = _targeting
	tilemap = _tilemap
	combat = _combat
	for actor in get_children():
		var coordinates = Grid.absolute_to_grid_coordinates(actor.global_position)
		Grid.game_board.set(coordinates, actor)
		actor.init(coordinates)

func sleep():
	for actor in get_children():
		actor.sleep()

func character_act(character: Character):
	is_character_acting = true
	var action: Action = await combat_menu.make_action_selection(character.actions)
	
	if action is Action.Move:
		var target_payload = await targeting.begin_targeting(action.targeting_config)
		var path: PackedVector2Array = target_payload[1]
		GameState.input_allowed = false
		await character.move(path)
		var final_coords = Grid.absolute_to_grid_coordinates(path[path.size()-1])
		Grid.game_board.erase(character.grid_coordinates)
		Grid.game_board.set(final_coords, character)
		character.grid_coordinates = final_coords
		GameState.input_allowed = true
	elif action is Action.Attack:
		var target_payload = await targeting.begin_targeting(action.targeting_config)
		var target = Grid.get_actor(target_payload[0])
		GameState.input_allowed = false
		await combat.initiate(character, target)
		GameState.input_allowed = true
		
	character.deactivate()
	is_character_acting = false
	

func _on_tilemap_tile_selected(coordinates: Vector2i) -> void:
	if GameState.input_allowed && !is_character_acting:
		var character = Grid.get_actor(coordinates)
		if character == null:
			return
		if character.state != Character.States.ready:
			return
		if character.team != GameState.active_team:
			return
		character.activate()
		await character_act(character)
