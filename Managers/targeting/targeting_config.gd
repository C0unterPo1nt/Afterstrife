class_name TargetingConfig extends Resource

var potential_targets: TileMask
var preview_path: bool
var path_obstacles: TileMask

func _init(_potential_targets: TileMask, _preview_path: bool = true, _path_obstacles: TileMask = null) -> void:
	potential_targets = _potential_targets
	preview_path = _preview_path
	if _path_obstacles != null:
		path_obstacles = _path_obstacles
	else:
		path_obstacles = potential_targets

class TileMask extends Resource:
	var obstacles: bool
	var allies: bool
	var enemies: bool
	var empty_tiles: bool
	
	func _init(_obstacles: bool, _allies: bool, _enemies: bool, _empty_tiles: bool) -> void:
		obstacles = _obstacles
		allies = _allies
		enemies = _enemies
		empty_tiles = empty_tiles
