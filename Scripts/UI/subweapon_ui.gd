extends Control

@export var icon_texture_rect : TextureRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_player_subweapon_changed(new_subweapon : SubweaponDataResource) -> void:
	if (new_subweapon == null):
		icon_texture_rect.texture = null
		return
	
	if (new_subweapon.Scene == null):
		icon_texture_rect.texture = null
		return
	
	icon_texture_rect.texture = new_subweapon.Icon
