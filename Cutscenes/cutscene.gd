extends Control

signal done
var is_done: bool = false
@onready var tab_container = $PageContainer

func _ready() -> void:
	for page in tab_container.get_children():
		page.done.connect(_on_page_done)
	tab_container.get_current_tab_control().start()

func _on_page_done():
	if tab_container.current_tab == tab_container.get_tab_count() -1:
		end()
	else:
		tab_container.current_tab += 1
		tab_container.get_current_tab_control().start()

func _process(delta):
	if Input.is_action_pressed("skip_cutscene"):
		end()

func end():
	if !is_done:
		print('end')
		is_done = true
		done.emit()
