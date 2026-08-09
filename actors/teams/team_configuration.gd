class_name TeamConfiguration extends Resource

@export var team: Team
@export var members: Array[PackedScene]

func _init(_team: Team, characters: Array[PackedScene]) -> void:
	team = _team
	members = characters
