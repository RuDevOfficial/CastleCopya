extends Control

@export var icon_texture_rect : TextureRect

func _ready() -> void:
	var node : SubweaponManager = get_tree().root.get_node("Main/Player/Managers/Subweapon Manager")
	node.on_subweapon_swapped.connect(update_icon)

func update_icon(new_subweapon) -> void:
	if (new_subweapon == null):
		icon_texture_rect.texture = null
		return
	
	if (new_subweapon.Scene == null):
		icon_texture_rect.texture = null
		return
	
	icon_texture_rect.texture = new_subweapon.Icon
