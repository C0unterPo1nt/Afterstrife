extends Node

func _init() -> void:
	call_deferred("resize")

func resize():
	print('resizing')
	#get_node("/root").content_scale_size = Vector2i(1920,1080)
