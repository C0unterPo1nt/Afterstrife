extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("animation_finished", _on_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func dim():
	modulate = Color(.5,.5,.5)

func undim():
	modulate = Color(1,1,1)

func _on_animation_finished():
	play("default")
