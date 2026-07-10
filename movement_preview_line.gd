extends Node2D

var path: PackedVector2Array
var arrow = load("res://MovementPreviewLine.png")
var arrow_regions: Dictionary = { "straight": Rect2(0,0,32,32), "point": Rect2(32,0,32,32), "bend": Rect2(64,0,32,32), "pointbend": Rect2(96,0,32,32)}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_character_update_state(state: Constants.CharacterStates):
	kill_children()

func kill_children():
	for node in get_children():
		node.queue_free()

func _on_update_path_preview(_path: PackedVector2Array):
	path = _path
	kill_children()
	draw_line_sprites()
		

func draw_line_sprites():
	var first = true
	var second = true
	for i in path.size():
		var point = path[i]
		# Skip the first and last points
		if i == 0 || i == path.size() - 1:
			continue
		var next_point = path[i+1]
		var prev_point = path[i-1]
		var direction_to_next = point.direction_to(next_point)
		var direction_to_prev = point.direction_to(prev_point)

		if direction_to_next.dot(direction_to_prev) == 0:
			var flip_v = false
			if direction_to_next.angle_to(direction_to_prev) < 0:
				flip_v = true
			if i == path.size() - 2:
				instance_sprite(point, 'pointbend', direction_to_next.angle(), flip_v)
			else:
				instance_sprite(point, 'bend', direction_to_next.angle(), flip_v)
			continue
		if i == path.size() - 2:
			instance_sprite(point, 'point', direction_to_next.angle())
			continue
		print(direction_to_next.angle())
		instance_sprite(point, 'straight', direction_to_next.angle())

func instance_sprite(coords, type, rotate=0, flip_v=false):
	var sprite = Sprite2D.new()
	sprite.texture = arrow
	sprite.region_enabled = true
	sprite.region_rect = arrow_regions[type]
	sprite.flip_v = flip_v
	sprite.rotation = rotate
	sprite.global_position = coords + Vector2(Grid.cell_size/2)
	add_child(sprite)
