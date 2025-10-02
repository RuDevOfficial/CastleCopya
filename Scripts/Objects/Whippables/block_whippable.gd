extends Whipable
# Whipable that acts as a solid block on which the player can stand on top of or collide with

@export var static_body : StaticBody2D

func additional_show_object() -> void: 
	static_body.set_collision_layer_value(1, true)
	static_body.set_collision_mask_value(1, true)

func additional_hide_object() -> void:	
	static_body.set_collision_layer_value(1, false)
	static_body.set_collision_mask_value(1, false)
