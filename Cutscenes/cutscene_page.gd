extends Control

@export var page_data: CutscenePageData
var active: bool = false
signal done

func start():
	$Background.texture = page_data.background
	$TextBox.update_label(page_data.get_next_block())
	active = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && active:
		if $TextBox.all_shown:
			advance()
		else:
			$TextBox.show_all()

func advance():
	var next = page_data.get_next_block()
	if next != null:
		$TextBox.update_label(next)
	else:
		active = false
		done.emit()
