extends Control

@export var label : Label
@export var player : PlayerCharacter

func _ready() -> void:
	pass

func _on_player_start(_playerResource : PlayerResource) -> void:
	label.text = str(_playerResource.SubweaponUses)

func _on_player_subweapon_used_trigger(_playerResource : PlayerResource) -> void:
	label.text = str(_playerResource.SubweaponUses)
