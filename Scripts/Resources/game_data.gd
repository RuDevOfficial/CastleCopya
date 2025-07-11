extends Resource
class_name GameDataResource

var LAST_SAVE_DATA_INDEX : int = 0

func game_data_to_dictionary() -> Dictionary:
	
	var new_dictionary = { 
		"LAST_SAVE_DATA_INDEX" = 0
	}
	
	return new_dictionary

func dictionary_to_game_data(dictionary) -> void:
	
	LAST_SAVE_DATA_INDEX = dictionary["LAST_SAVE_DATA_INDEX"]
