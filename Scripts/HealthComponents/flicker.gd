extends Node
class_name Flicker

@export var _targetSprite : Sprite2D

@export var _targetetSprites : Array[Sprite2D]

@export var _originalColor : Color
@export var _flickerColor : Color
@export var _flickerTimes : int
@export var _flickerTimeIndividual : float

var Flickering : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_health_damaged(amount: float, knockback: Vector2) -> void:
	Flickering = true
	if (_targetSprite != null): flicker_one()
	else: flicker_multiple()
	Flickering = false

func flicker_one():
	for i in _flickerTimes:
		_targetSprite.modulate = _flickerColor
		await get_tree().create_timer(_flickerTimeIndividual / 2.0).timeout
		_targetSprite.modulate = _originalColor
		await get_tree().create_timer(_flickerTimeIndividual / 2.0).timeout

func flicker_multiple():
	for i in _flickerTimes:
		for sprite in _targetetSprites: sprite.modulate = _flickerColor
		await get_tree().create_timer(_flickerTimeIndividual / 2.0).timeout
		for sprite in _targetetSprites: sprite.modulate = _originalColor
		await get_tree().create_timer(_flickerTimeIndividual / 2.0).timeout
