extends Node

signal click(Vector2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		click.emit(get_viewport().get_mouse_position())
