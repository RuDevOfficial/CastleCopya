@tool

extends BTAction
@export var sound_key : String

func _generate_name() -> String:
	return "Play Sound: " + sound_key

func _tick(delta: float) -> Status:
	var result : bool = SfxManager.do_one_shot(sound_key)
	
	if (result == true): return SUCCESS
	else: return FAILURE
