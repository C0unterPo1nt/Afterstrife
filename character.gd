extends Area2D

enum States {ready, move, declare_move, idle}

signal calculate_path(Node, Vector2)

@export var state: States = States.idle
@export var movement_speed: float = 64
var movement_delta: float
var path: PackedVector2Array = PackedVector2Array([global_position])
var target: Vector2 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = global_position
	pass # Replace with function body.

func _process(delta: float) -> void:
	$MovementReticleSprite.visible = false
	$MovementPreviewLine.visible = false

	match state:
		States.declare_move:
			$MovementReticleSprite.visible = true
			$MovementPreviewLine.visible = true
			var new_position = $Helpers.snap_to_grid(get_viewport().get_camera_2d().get_global_mouse_position())
			if new_position != $MovementReticleSprite.global_position:
				$MovementReticleSprite.global_position = new_position
				calculate_path.emit($".", new_position)

func _physics_process(delta):
	match state:
		States.move:
			if global_position.distance_to(target) < 1:
				global_position = target
				if path.is_empty():
					state = States.idle
					return
				target = path[0]
				path = path.slice(1)
			movement_delta = movement_speed * delta
			var next_path_position: Vector2 = target
			var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
			global_position = global_position.move_toward(global_position + new_velocity, movement_delta)

func move():
	state = States.move
	

func set_path(_path: PackedVector2Array):
	print('rendering', _path)
	path = _path
	var path_offset = PackedVector2Array()
	for point in _path:
		path_offset.append(point - global_position + Vector2($Helpers.cell_size/2))
	$MovementPreviewLine.points = path_offset
	

func _on_click(_coordinates) -> void:
	match state:
		States.idle:
			if $Helpers.snap_to_grid(_coordinates) != global_position:
				return
			state = States.declare_move
		States.declare_move:
			move()
