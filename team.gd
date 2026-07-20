class_name Team

extends Resource

@export var name: String

var actors: Dictionary[Vector2i, Character]

func refresh(): 
	for actor in actors.values():
		actor.refresh()
