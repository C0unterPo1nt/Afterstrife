extends Node2D

enum States {targeting, sleeping}

var state: States = States.sleeping
var character: Character
var path: PackedVector2Array
var tilemap: TileMapLayer
@onready var click = $'../../Input'.click

func _ready():
	tilemap = $'../Tilemap'

func move(_character: Character) -> PackedVector2Array:
	character = _character
	activate()
	await click
	sleep()
	return path

func target_character():
	pass

func _process(delta: float) -> void:
	if state == States.targeting:
		var new_position = get_snapped_mouse_position()
		if new_position != $MovementReticleSprite.global_position:
			update_reticle_and_line(new_position)

func update_reticle_and_line(new_position: Vector2):
	$MovementReticleSprite.global_position = new_position
	path = tilemap.calculate_path(character.grid_coordinates, Grid.absolute_to_grid_coordinates(new_position), [character.grid_coordinates])
	$MovementPreviewLine.update_path_preview(path)

func get_snapped_mouse_position():
	return Grid.snap_to_grid(get_viewport().get_camera_2d().get_global_mouse_position())

func visible(is_visible):
	$MovementReticleSprite.visible = is_visible
	$MovementPreviewLine.visible = is_visible
	
func activate():
	state = States.targeting
	update_reticle_and_line(get_snapped_mouse_position())
	visible(true)

func sleep():
	state = States.sleeping
	visible(false)
