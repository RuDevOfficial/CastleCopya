@tool
extends BTAction

@export var _packedScene : PackedScene
@export var _samePosition : bool
@export var _positionKey : String

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Spawn Scene"

# Called to initialize the task.
func _setup() -> void:
	pass

# Called when the task is entered.
func _enter() -> void:
	pass

# Called when the task is exited.
func _exit() -> void:
	pass

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if (_packedScene == null):
		return FAILURE
		
	var new_scene = _packedScene.instantiate()
	agent.get_tree().root.add_child(new_scene)
	if (_samePosition == true):
		new_scene.global_position = agent.global_position
	else:
		new_scene.global_position = blackboard.get_var(_positionKey)
	
	return SUCCESS

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
