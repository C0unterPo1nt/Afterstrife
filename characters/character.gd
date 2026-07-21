class_name Character

extends Area2D

enum States {ready, declare, acting, tapped, sleep}

@export var state: States = States.ready

@export var grid_coordinates: Vector2i
@export var activated: bool = false
@export var stats: CharacterStats
@export var team: Team
var game_board: Dictionary[Vector2i, Character]

var actions: Array[Action] = [
	Action.Move.new(),
	Action.Attack.new()
]

func init(_grid_coordinates: Vector2i, _game_board: Dictionary[Vector2i, Character]):
	grid_coordinates = _grid_coordinates
	game_board = _game_board

func _ready() -> void:
	$HealthBar.max_value = stats.max_health
	$HealthBar.value = stats.health
	team.actors.append(self)

func activate():
	if state != States.ready:
		return
	activated = true
	state = States.declare
	
func deactivate():
	activated = false
	stats.remaining_actions = stats.remaining_actions - 1
	if stats.remaining_actions == 0:
		state = States.tapped
		$CharacterSprite.dim()

func refresh():
	state = States.ready
	stats.remaining_actions = stats.maximum_actions
	$CharacterSprite.undim()

func sleep():
	state = States.sleep
	$CharacterSprite.undim()

func damage(ammount: int):
	stats.health -= ammount
	$HealthBar.value = stats.health
	$CharacterSprite.play("damage")
	await $CharacterSprite.animation_finished
	if stats.health <= 0:
		die()

func attack(defender: Character):
	$CharacterSprite.play("attack")
	defender.damage(stats.attack_strength)
	await $CharacterSprite.animation_finished

func die():
	game_board.erase(grid_coordinates)
	team.actors.erase(self)
	team.check_defeated()
	queue_free()
