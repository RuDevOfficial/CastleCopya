extends Node

@export var _initialState : State
@export var _playerResource : PlayerResource

var _currentState : State
var _states : Dictionary = {}

func _ready() -> void:	
	for child in get_children():
		if child is State:
			_states.get_or_add(child.name.to_lower(), child)
			child.Exiting.connect(on_child_transition)
			child._playerResource = _playerResource
			
	if (_initialState):
		_initialState.Enter()
		_currentState = _initialState

func _process(delta: float) -> void:
	if (_currentState):
		_currentState.Update(delta)

func _physics_process(delta: float) -> void:
	if (_currentState):
		_currentState.Physics_Update(delta)

func on_child_transition(state, new_state_name : String) -> void:
	if (state != _currentState):
		return
	
	var new_state = _states.get(new_state_name.to_lower())
	if (!new_state):
		return
	
	if (_currentState):
		_currentState.Exit()
	
	_currentState = new_state
	_currentState.Enter()
