extends Node2D

func refresh():
	for actor in get_children():
		actor.refresh()
