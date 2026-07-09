class_name Character

extends Area2D

signal calculate_path(start:Vector2i, destination:Vector2i, callback:Callable, mask:Array[Vector2i])
signal done
signal moved(from:Vector2i, to:Vector2i)
signal update_preview_path(path:PackedVector2Array)
signal update_state(state:Constants.CharacterStates)

@export var state: Constants.CharacterStates = Constants.CharacterStates.idle
@export var movement_speed: float = 64
var movement_delta: float
var path: PackedVector2Array = PackedVector2Array([global_position])
var target: Vector2 
var grid_coordinates: Vector2i


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = global_position
	pass # Replace with function body.

func _process(delta: float) -> void:
	$MovementReticleSprite.visible = false

	match state:
		Constants.CharacterStates.declare_move:
			$MovementReticleSprite.visible = true
			var new_position = $Helpers.snap_to_grid(get_viewport().get_camera_2d().get_global_mouse_position())
			if new_position != $MovementReticleSprite.global_position:
				$MovementReticleSprite.global_position = new_position
				calculate_path.emit(grid_coordinates, $Helpers.absolute_to_grid_coordinates(new_position), set_path, [grid_coordinates])

func _physics_process(delta):
	match state:
		Constants.CharacterStates.move:
			if global_position.distance_to(target) < 1:
				global_position = target
				if path.is_empty():
					state = Constants.CharacterStates.idle
					var new_coordinates = $Helpers.absolute_to_grid_coordinates(global_position)
					moved.emit(grid_coordinates, new_coordinates)
					grid_coordinates = new_coordinates
					done.emit()
					return
				target = path[0]
				path = path.slice(1)
			movement_delta = movement_speed * delta
			var next_path_position: Vector2 = target
			var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
			global_position = global_position.move_toward(global_position + new_velocity, movement_delta)

func change_state(_state: Constants.CharacterStates):
	state = _state
	update_state.emit(state)
	
func activate():
	state = Constants.CharacterStates.declare_move

func set_path(_path: PackedVector2Array):
	path = _path
	var path_offset = PackedVector2Array()
	for point in _path:
		path_offset.append(point - global_position + Vector2($Helpers.cell_size/2))
	update_preview_path.emit(path)
	

func _on_click(_coordinates) -> void:
	match state:
		Constants.CharacterStates.declare_move:
			change_state(Constants.CharacterStates.move)
