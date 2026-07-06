extends CharacterBody2D

enum States {move, idle}

@export var state: States

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if state == States.move:
		$MovementReticleSprite.visible = true
		var new_position = $Helpers.snap_to_grid(get_viewport().get_camera_2d().get_global_mouse_position())
		if new_position != $MovementReticleSprite.global_position:
			$MovementReticleSprite.global_position = new_position

func _on_click(_position):
	match state:
		States.move:
			global_position = $Helpers.snap_to_grid(_position)
			state = States.idle
			$MovementReticleSprite.visible = false
		States.idle:
			if global_position == $Helpers.snap_to_grid(_position):
				state = States.move
