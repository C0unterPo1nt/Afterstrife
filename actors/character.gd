class_name Character

extends Node2D

enum States {ready, declare, acting, tapped, sleep}

@export var state: States = States.ready

@export var grid_coordinates: Vector2i
@export var activated: bool = false
@export var stats: CharacterStats
@export var team: Team

func init(_grid_coordinates: Vector2i):
	grid_coordinates = _grid_coordinates

func _ready() -> void:
	#stats.health = stats.max_health
	$HealthBar.max_value = stats.max_health
	$HealthBar.value = stats.health
	team.actors.append(self)

func _process(delta: float) -> void:
	if GameState.input_allowed:
		if Grid.absolute_to_grid_coordinates(get_viewport().get_mouse_position()) == grid_coordinates:
			should_display_health(true)
		else:
			should_display_health(false)

func activate():
	if state != States.ready:
		return
	activated = true
	$ReadyIndicator.visible = false
	state = States.declare
	
func deactivate():
	activated = false
	stats.remaining_actions = stats.remaining_actions - 1
	if stats.remaining_actions == 0:
		state = States.tapped
		$ReadyIndicator.visible = false
		$CharacterSprite.dim()
	else:
		state = States.ready
		$ReadyIndicator.visible = true

func refresh():
	state = States.ready
	stats.remaining_actions = stats.maximum_actions
	$ReadyIndicator.visible = true
	$CharacterSprite.undim()

func sleep():
	state = States.sleep
	$ReadyIndicator.visible = false
	$CharacterSprite.undim()

func damage(ammount: int):
	stats.health -= ammount
	$HealthBar.value = stats.health
	should_display_health(true)
	$CharacterSprite.play("damage")
	await $CharacterSprite.animation_finished
	should_display_health(false)
	if stats.health <= 0:
		die()

func attack(defender: Character):
	$CharacterSprite.play("attack")
	defender.damage(stats.attack_strength)
	await $CharacterSprite.animation_finished

func die():
	Grid.game_board.erase(grid_coordinates)
	team.actors.erase(self)
	team.check_defeated()
	queue_free()
	
func move(path: PackedVector2Array):
	await $Movement.move(self, path)

func should_display_health(should: bool):
	$HealthBar.visible = should
