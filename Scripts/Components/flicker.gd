extends Node
class_name Flicker
# Health-based component that flickers a single or multiple children sprites

@export var target_sprite : Sprite2D

@export var targeted_sprites : Array[Sprite2D]

@export var original_color : Color = Color.WHITE
@export var flicker_color : Color
@export var flicker_times : int
@export var time_per_single_flicker : float

var Flickering : bool = false

func _on_health_damaged(_amount: float, _knockback: Vector2) -> void:
	Flickering = true
	if (target_sprite != null): flicker_one()
	else: flicker_multiple()
	Flickering = false

func flicker_one():
	for i in flicker_times:
		target_sprite.modulate = flicker_color
		await get_tree().create_timer(time_per_single_flicker / 2.0).timeout
		target_sprite.modulate = original_color
		await get_tree().create_timer(time_per_single_flicker / 2.0).timeout

func flicker_multiple():
	for i in flicker_times:
		for sprite in targeted_sprites: sprite.modulate = flicker_color
		await get_tree().create_timer(time_per_single_flicker / 2.0).timeout
		for sprite in targeted_sprites: sprite.modulate = original_color
		await get_tree().create_timer(time_per_single_flicker / 2.0).timeout
