extends Control
# Class that shows the current hearts available.

@export var label : Label
@export var player : PlayerCharacter

func _ready() -> void:
	var node : SubweaponManager = get_tree().root.get_node("Main/Player/Managers/Subweapon Manager")
	node.on_weapon_use.connect(update_count)
	node.on_weapon_refill.connect(update_count)

func update_count(amount : int) -> void:
	label.text = str(amount)
