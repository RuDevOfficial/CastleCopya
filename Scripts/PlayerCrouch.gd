extends State
class_name PlayerCrouch
@export var _animationTree : AnimationTree

func Enter() -> void:
	_animationTree.set("parameters/conditions/crouching", true)
	_animationTree.set("parameters/conditions/notCrouching", false)
	_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)

func Exit() -> void:
	_animationTree.set("parameters/conditions/crouching", false)
	_animationTree.set("parameters/conditions/notCrouching", true)
	_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)

func Update(_delta : float) -> void:
	if (Input.is_action_pressed("move_right")):
		_playerResource.LastDirection = 1
		_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)
	elif (Input.is_action_pressed("move_left")):
		_playerResource.LastDirection = -1
		_animationTree.set("parameters/Crouching/blend_position", _playerResource.LastDirection)

	if (Input.is_action_just_released("crouch")):
		Exiting.emit(self, "Normal")

func Physics_Update(_delta : float) -> void:
	pass
