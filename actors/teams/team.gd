class_name Team

extends Resource

@export var name: String
var defeated: bool = false

var actors: Array[Character]

func refresh(): 
	for actor in actors:
		actor.refresh()

func check_defeated():
	if actors.is_empty():
		defeated = true

func clear():
	actors = []
	defeated = false
