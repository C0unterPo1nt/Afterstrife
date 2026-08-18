extends Node2D

signal done
signal turn(bool)

var character: Character
var path: PackedVector2Array
var progress: int
var moving: bool
@export var movement_speed: float = 128

func move(_character: Character, _path: PackedVector2Array):
	progress = 0
	character = _character
	path = _path
	moving = true
	await done
	moving = false
	var final_coords = Grid.absolute_to_grid_coordinates(path[path.size()-1])
	_update_board(final_coords)
	character = null

func teleport(_character: Character, _destination: Vector2):
	character = _character
	_character.position = _destination
	_update_board(Grid.absolute_to_grid_coordinates(_destination))
	character = null

func _update_board(coords: Vector2i):
	Grid.game_board.erase(character.grid_coordinates)
	Grid.game_board.set(coords, character)
	character.grid_coordinates = coords

	
func _physics_process(delta):
	if moving:
		var destination = path[progress]
		if character.global_position.distance_to(destination) < 1:
			character.global_position = destination
			if progress == path.size() - 1:
				moving = false
				done.emit(character)
				return
			progress += 1
			if path[progress].direction_to(global_position).x > 0:
				turn.emit(true)
			elif path[progress].direction_to(global_position).x < 0:
				turn.emit(false)
		var movement_delta = movement_speed * delta
		character.global_position = character.global_position.move_toward(destination, movement_delta)

	
