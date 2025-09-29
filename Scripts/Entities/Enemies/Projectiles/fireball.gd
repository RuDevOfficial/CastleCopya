extends RigidBody2D

@export var speed : float
@export var lifetime : float

@onready var sprite_component : Sprite2D = $Sprite2D

var start_direction : float
var disabled : bool

func _ready() -> void:
	do_enable(false)

func set_values(direction : float) -> void:
	start_direction = direction
	if (start_direction == 1): sprite_component.flip_h = true
	else: sprite_component.flip_h = false

func _physics_process(delta: float) -> void:
	move_and_collide((Vector2.RIGHT * start_direction) * (speed * delta))

func do_enable(result : bool) -> void:
	visible = result
	set_physics_process(result)
	disabled = !result
	
	if (result == true):
		get_tree().create_timer(lifetime).timeout.connect(func(): do_enable(false))

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	do_enable(false)
