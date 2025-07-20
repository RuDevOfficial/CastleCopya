extends AnimatableBody2D
class_name Boss

@export var health : Health
@export var behavior_reference : BTPlayer
@export var stun_time : float
@export var boss_theme_music : String

var original_speed : float

func _ready() -> void:
	original_speed = behavior_reference.blackboard.get_var("speed")
	set_ready_values()

func set_ready_values() -> void:
	pass #THIS SHOULD BE OVERWRITTEN ON INHERITING CLASSES

func initialize() -> void:
	behavior_reference.blackboard.set_var("starting_position", global_position)
	behavior_reference.active = true

func _on_health_damaged(amount: float, knockback: Vector2) -> void:
	SignalBus.on_enemy_hit.emit(self, health.max_health, health.get_current())
	
	behavior_reference.blackboard.set_var("speed", 0)
	await get_tree().create_timer(stun_time).timeout
	behavior_reference.blackboard.set_var("speed", original_speed)

func _on_health_death() -> void:
	SignalBus.on_enemy_death.emit()
	SignalBus.on_boss_death.emit()
	queue_free()
