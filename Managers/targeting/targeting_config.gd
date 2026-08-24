class_name TargetingConfig extends Resource

var potential_targets: TileMask
var preview_path: bool
var path_obstacles: TileMask
var predicate: Callable

func _init(_predicate, _potential_targets: TileMask, _preview_path: bool = true, _path_obstacles: TileMask = null) -> void:
	predicate = _predicate
	potential_targets = _potential_targets
	preview_path = _preview_path
	if _path_obstacles != null:
		path_obstacles = _path_obstacles
	else:
		path_obstacles = potential_targets

class TileMask extends Resource:
	var _self: bool
	var allies: bool
	var enemies: bool
	var obstacles: bool
	var empty_tiles: bool
	
	func _init(__self: bool, _allies: bool, _enemies: bool, _obstacles: bool, _empty_tiles: bool) -> void:
		_self = __self
		allies = _allies
		enemies = _enemies
		obstacles = _obstacles
		empty_tiles = _empty_tiles
