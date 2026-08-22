class_name CutscenePageData extends Resource

@export var background: Texture
@export var text_blocks: Array[String] = [
	"Hello",
	"Test"
]
var _current = 0

func get_next_block():
	if _current >= text_blocks.size():
		return null
	else:
		var next = text_blocks[_current]
		_current += 1
		return next
