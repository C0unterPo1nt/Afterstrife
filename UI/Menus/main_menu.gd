extends Control

var game = preload("res://game.tscn")

@export var character_previews: Array[CharacterPreview]

func _ready() -> void:
	$TabContainer/GameSetupPageContainer.init(character_previews)
	$TabContainer/UnitCatalogue.init(character_previews)

func _on_back_button_pressed() -> void:
	$TabContainer.current_tab = 1

func _on_info_button_pressed() -> void:
	$TabContainer.current_tab = 2

func _on_play_game_button_pressed() -> void:
	$TabContainer.current_tab = 3

func _on_units_button_pressed() -> void:
	$TabContainer.current_tab = 4

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _on_tab_container_tab_changed(tab: int) -> void:
	if $TabContainer.current_tab <= 1:
		$BackButton.visible = false
	else:
		$BackButton.visible = true

func _on_cutscene_done() -> void:
	$TabContainer.current_tab = 1
