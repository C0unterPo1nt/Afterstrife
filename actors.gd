extends Node

func refresh():
	for actor in get_children():
		actor.refresh()
