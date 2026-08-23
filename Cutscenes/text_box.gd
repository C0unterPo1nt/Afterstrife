extends Control

var text: String
var shown_char_index: int
var all_shown: bool
var time_since_last_update: float = 0
var characters_per_second: float = .03

func update_label(_text: String):
	text = _text
	shown_char_index = 0
	$TextLabel.text = ""
	all_shown = false
	$AdvancePrompt.hide()

func show_all():
	$TextLabel.text = text
	complete()

func complete():
	all_shown = true
	$AdvancePrompt.visible = true

func _process(delta: float) -> void:
	time_since_last_update += delta
	if time_since_last_update >= characters_per_second and not all_shown:
		shown_char_index += 1
		$TextLabel.text = text.substr(0, shown_char_index)
		time_since_last_update = 0
		if shown_char_index >= text.length():
			complete()
