extends State
class_name PlayerSubweapon
# This state triggers when attempting to use a subweapon (and it succeeded)

@export var normal_state : PlayerNormal

func Enter() -> void:
	
	# Spawn subweapon
	var subweapon : Subweapon = player_resource.CurrentSubweapon.instantiate()
	get_tree().root.get_node("Main").add_child(subweapon)
	subweapon.global_position = player_resource.Agent.global_position
	
	# Create a delay between throows
	var timer = get_tree().create_timer(subweapon.Subweapon_Resource.ThrowDelay)
	timer.timeout.connect(_on_timeout)
	
	# Trigger the "throw" method on the subweapon
	# Any modifiers inside this subweapon will be triggered
	# (Check the Axe.tscn packaged scene for an example)
	subweapon.throw(Vector2(player_resource.LastDirection, 0))

func Exit() -> void:
	pass

func Update(_delta : float) -> void:
	pass

func Physics_Update(delta : float) -> void:
	# Runs the same physics update as the normal state
	normal_state.Physics_Update(delta)

func _on_timeout() -> void:
	Exiting.emit(self, "Normal")
