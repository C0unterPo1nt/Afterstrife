class_name Character

extends Node2D

enum States {ready, declare, acting, tapped, sleep}

@export var state: States = States.ready

@export var grid_coordinates: Vector2i
@export var activated: bool = false
@export var stats: CharacterStats
@export var team: Team
var targeting: Node

func init(_grid_coordinates: Vector2i, _team: Team, _targeting: Node):
	grid_coordinates = _grid_coordinates
	team = _team
	team.actors.append(self)
	set_team_indicator_color(team)
	targeting = _targeting

func _ready() -> void:
	$HealthBar.max_value = stats.max_health
	$HealthBar.value = stats.health

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
	#TODO: get rid of the self param
	var action: Action = await $ActionMenu.make_action_selection(self)
	await action.act(self, targeting)
	deactivate()
	
func deactivate():
	activated = false
	stats.remaining_actions = stats.remaining_actions - 1
	if stats.remaining_actions <= 0:
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

func change_health(ammount: int, animation: String):
	clamp(ammount, stats.health, stats.max_health - stats.health)
	stats.health += ammount
	$HealthBar.value = stats.health
	should_display_health(true)
	$CharacterSprite.play(animation)
	await $CharacterSprite.animation_finished
	should_display_health(false)
	if stats.health <= 0:
		die()

func attack(defender: Character):
	if defender.grid_coordinates.x < grid_coordinates.x:
		$CharacterSprite.flip_h = true
	elif defender.grid_coordinates.x > grid_coordinates.x:
		$CharacterSprite.flip_h = false
	$CharacterSprite.play("attack")
	defender.change_health(-stats.attack_strength, "damage")
	await $CharacterSprite.animation_finished

func heal(target: Character):
	$CharacterSprite.play("attack")
	await $CharacterSprite.animation_finished
	target.change_health(stats.heal_strength, "default")

func die():
	Grid.game_board.erase(grid_coordinates)
	team.actors.erase(self)
	team.check_defeated()
	queue_free()
	
func move(path: PackedVector2Array):
	await $Movement.move(self, path)

func teleport(coords: Vector2):
	await  $Movement.teleport(self, coords)

func should_display_health(should: bool):
	$HealthBar.visible = should

func set_team_indicator_color(team: Team):
	$TeamIndicator.color = team.color

func is_at_max_health():
	return stats.health == stats.max_health

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && GameState.input_allowed && !GameState.is_character_acting:
		var _position = Grid.snap_to_grid(get_viewport().get_mouse_position())
		if _position != position:
			return
		if state != Character.States.ready:
			return
		if team != GameState.active_team:
			return
		GameState.is_character_acting = true
		await activate()
		GameState.is_character_acting = false
