extends Node

@export var initial_state : State
@export var player_resource : PlayerResource

var current_state : State
var states : Dictionary = {}

func _ready() -> void:	
	
	for child in get_children():
		if child is State:
			states.get_or_add(child.name.to_lower(), child)
			child.Exiting.connect(on_child_transition)
			child.player_resource = player_resource
	
	if (initial_state):
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if (current_state):
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if (current_state):
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name : String) -> void:
	if (state != current_state):
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if (!new_state):
		return
	
	if (current_state):
		current_state.Exit()
	
	current_state = new_state
	current_state.Enter()
