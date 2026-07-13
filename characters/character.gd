class_name Character

extends Area2D

enum States {ready, declare, acting, tapped}

@export var state: States = States.ready

@export var grid_coordinates: Vector2i
@export var activated: bool = false
var maximum_actions: int = 2
var remaining_actions: int = maximum_actions

var actions: Array[Action] = [
	Action.Move.new()
]

func _process(delta: float) -> void:
	if remaining_actions == 0 and state != States.tapped:
		end_turn()
	
func activate():
	if state != States.ready:
		return
	activated = true
	state = States.declare
	
func end_turn():
	activated = false
	state = States.tapped
	$CharacterSprite.dim()

func refresh():
	state = States.ready
	remaining_actions = maximum_actions
	$CharacterSprite.undim()
	
