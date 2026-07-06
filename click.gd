extends Node

signal click

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var camera = get_viewport().get_camera_2d()
		click.emit(camera.get_global_mouse_position())
