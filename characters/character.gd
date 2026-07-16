class_name Character

extends Area2D

enum States {ready, declare, acting, tapped}

@export var state: States = States.ready

@export var grid_coordinates: Vector2i
@export var activated: bool = false
@export var stats: CharacterStats

var actions: Array[Action] = [
	Action.Move.new(),
	Action.Attack.new()
]

func _ready() -> void:
	$HealthBar.max_value = stats.max_health
	$HealthBar.value = stats.health

func _process(delta: float) -> void:
	if stats.remaining_actions == 0 and state != States.tapped:
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
	stats.remaining_actions = stats.maximum_actions
	$CharacterSprite.undim()

func damage(ammount: int):
	stats.health -= ammount
	$HealthBar.value = stats.health
	$CharacterSprite.play("damage")

func attack():
	$CharacterSprite.play("attack")
	return stats.attack_strength
