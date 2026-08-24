extends Node2D

var target_preview_indicator = load("res://Managers/targeting/target_preview_indicator.tscn")
signal target_selected(coords: Vector2i, path: PackedVector2Array)

func _process(delta: float) -> void:
	if Input.is_action_just_released("cancel"):
		deactivate(null, null)

func create_target_indicator(coords: Vector2i, path: PackedVector2Array, preview_path: bool):
		var indicator = target_preview_indicator.instantiate()
		indicator.init(path, coords, _on_target_preview_indicator_selected, preview_path)
		add_child(indicator)

func deactivate(coords, path):
	target_selected.emit(coords, path)
	for tile in get_children():
		tile.queue_free()

func _on_target_preview_indicator_selected(coords: Vector2i, path: PackedVector2Array):
	deactivate(coords, path)
