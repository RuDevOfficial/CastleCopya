extends Resource
class_name GameDataResource

var INTRO_VIEWED : bool = false
var CURRENT_LEVEL : int = 0

func game_data_to_dictionary() -> Dictionary:
	
	var new_dictionary = { 
		"INTRO_VIEWED" = INTRO_VIEWED,
		"CURRENT_LEVEL" = 0
	}
	
	return new_dictionary

func dictionary_to_game_data(dictionary) -> void:
	
	INTRO_VIEWED = dictionary["INTRO_VIEWED"]
	CURRENT_LEVEL = dictionary["CURRENT_LEVEL"]
