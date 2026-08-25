extends Node2D

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var effects_sprite: AnimatedSprite2D = $EffectsSprite

var flip_h:
	set(flipped):
		flip_h = flipped
		$CharacterSprite.flip_h = flipped
		$EffectsSprite.flip_h = flipped
var flip_v:
	set(flipped):
		flip_v = flipped
		$CharacterSprite.flip_v = flipped
		$EffectsSprite.flip_v = flipped
var fading: bool = false:
	set(is_fading):
		fading = is_fading
		fade_progress = 0
var fading_out: bool = false
var fade_progress: float = 0
var white = Color(1,1,1,1)

signal impact
signal animation_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_sprite.connect("animation_finished", _on_animation_finished)

func _process(delta: float) -> void:
	if fading:
		var color
		if fading_out:
			color = Color(0,0,0,0)
		else:
			color = white
		fade_progress = fade_progress + delta
		modulate = modulate.lerp(color, fade_progress)
		if fade_progress >= 1:
			fading = false
			animation_finished.emit()

func dim():
	modulate = Color(.5,.5,.5)

func undim():
	modulate = white

func fade(_fading_out: bool):
	fading_out = _fading_out
	fading = true

func _on_animation_finished():
	character_sprite.play("default")

func play_character_sprite_animation_with_impact(animation: StringName):
	character_sprite.play(animation)
	character_sprite.waiting_for_impact_frame = true
	await character_sprite.impact
	impact.emit()
	await character_sprite.animation_finished
	animation_finished.emit()

func attack():
	play_character_sprite_animation_with_impact("attack")

func heal():
	play_character_sprite_animation_with_impact("attack")

func damage():
	character_sprite.play("damage")
	await character_sprite.animation_finished
	animation_finished.emit()

func healed():
	effects_sprite.play("heal")
	await effects_sprite.animation_finished
	effects_sprite.play("default")
	animation_finished.emit()

func _on_movement_turn(bool: Variant) -> void:
	character_sprite.flip_h = bool
