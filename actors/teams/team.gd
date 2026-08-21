class_name Team

extends Resource

@export var name: String
@export var color: Color
var defeated: bool = false

signal team_member_removed(character: Character)

var actors: Array[Character]

func remove_character_from_team(character: Character):
	actors.erase(character)
	team_member_removed.emit(character)

func refresh(): 
	for actor in actors:
		actor.refresh()

func check_defeated():
	if actors.is_empty():
		defeated = true

func clear():
	actors = []
	defeated = false
