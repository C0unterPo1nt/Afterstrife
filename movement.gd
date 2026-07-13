extends Node2D

signal done

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
	character = null
	return
	
	
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
		var movement_delta = movement_speed * delta
		character.global_position = character.global_position.move_toward(destination, movement_delta)

	
