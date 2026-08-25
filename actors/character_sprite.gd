extends AnimatedSprite2D

signal impact

@export var impact_frame: int
var waiting_for_impact_frame: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting_for_impact_frame and frame == impact_frame:
		waiting_for_impact_frame = false
		impact.emit()
