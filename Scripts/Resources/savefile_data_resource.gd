extends Resource
class_name SavefileDataResource
# Base resource for storing a save data.
# You can add additional values to the dictionary related to only the savefile,
# for example the amount of blocks a player has broken (for achivement purposes)

var INTRO_VIEWED : bool = false # DON'T DELETE
var CURRENT_LEVEL : int = 0 # DON'T DELETE
# Add your new value here!

func game_data_to_dictionary() -> Dictionary:
	
	var new_dictionary = { 
		"INTRO_VIEWED" = INTRO_VIEWED, # DON'T DELETE
		"CURRENT_LEVEL" = CURRENT_LEVEL # DON'T DELETE
		# Add your new entry here!
	}
	
	return new_dictionary

func dictionary_to_game_data(dictionary) -> void:
	
	INTRO_VIEWED = dictionary["INTRO_VIEWED"] # DON'T DELETE
	CURRENT_LEVEL = dictionary["CURRENT_LEVEL"] # DON'T DELETE
	# Finally, get the value back from the dictionary here!
	
	
