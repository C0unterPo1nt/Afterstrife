class_name Character

extends Node2D

enum States {ready, declare, acting, tapped, sleep}

@export var state: States = States.ready

var action_menu: Node
@export var grid_coordinates: Vector2i
@export var stats: CharacterStats
@export var team: Team
@onready var sprite_handler: Node = $SpriteHandler
var targeting: Targeting
var health: int:
	set(ammount):
		health = clamp(ammount, 0, stats.max_health)
		$HealthBar.value = health
var remaining_actions: int = 0

func init(_grid_coordinates: Vector2i, _team: Team, _targeting: Node, _action_menu: Node):
	grid_coordinates = _grid_coordinates
	team = _team
	team.actors.append(self)
	set_team_indicator_color(team)
	targeting = _targeting
	action_menu = _action_menu

func _ready() -> void:
	$HealthBar.max_value = stats.max_health
	health = stats.max_health

func _process(delta: float) -> void:
	if GameState.input_allowed:
		var mouse_coordinates = Grid.absolute_to_grid_coordinates(get_viewport().get_mouse_position())
		if mouse_coordinates == grid_coordinates && !action_menu.visible:
			should_display_health(true)
		else:
			should_display_health(false)

func activate():
	if state != States.ready:
		return
	$ReadyIndicator.visible = false
	state = States.declare
	var success = false
	while !success:
		var action: Action = await action_menu.make_action_selection(self)
		if action == null:
			unactivate()
			return
		success = await action.act(self, targeting)
	deactivate()

func unactivate():
	state = States.ready
	$ReadyIndicator.visible = true

func deactivate():
	unactivate()
	remaining_actions = remaining_actions - 1
	if remaining_actions <= 0:
		state = States.tapped
		$ReadyIndicator.visible = false
		$SpriteHandler.dim()


func refresh():
	state = States.ready
	remaining_actions = stats.maximum_actions
	$ReadyIndicator.visible = true
	$SpriteHandler.undim()

func sleep():
	state = States.sleep
	$ReadyIndicator.visible = false
	$SpriteHandler.undim()

func change_health(ammount: int):
	health = health + ammount

func die():
	Grid.game_board.erase(grid_coordinates)
	team.actors.erase(self)
	team.check_defeated()
	queue_free()
	
func move(path: PackedVector2Array):
	await $Movement.move(self, path)

func teleport(coords: Vector2):
	$Movement.teleport(self, coords)

func should_display_health(should: bool):
	$HealthBar.visible = should

func set_team_indicator_color(team: Team):
	$SpriteHandler/TeamIndicator.color = team.color

func is_at_max_health():
	return health >= stats.max_health

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
