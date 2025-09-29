extends State
class_name PlayerSubweapon
@export var normal_state : PlayerNormal

func Enter() -> void:
	var subweapon : Subweapon = player_resource.CurrentSubweapon.instantiate()
	get_tree().root.get_node("Main").add_child(subweapon)
	subweapon.global_position = player_resource.Agent.global_position
	
	var timer = get_tree().create_timer(subweapon.Subweapon_Resource.ThrowDelay)
	timer.timeout.connect(_on_timeout)
	
	subweapon.throw(Vector2(player_resource.LastDirection, 0))

func Exit() -> void:
	pass

func Update(_delta : float) -> void:
	pass

func Physics_Update(delta : float) -> void:
	normal_state.Physics_Update(delta)

func _on_timeout() -> void:
	Exiting.emit(self, "Normal")
