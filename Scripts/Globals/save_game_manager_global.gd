extends Node
class_name SaveGameManager
# Class that manages saving and loading data
# Currently there is only one save file being used, although
# the support for multiple save files is already here. Just change the current_save_file_index.

signal on_generate_new_gameplay_save_data(game_data_resource : SavefileDataResource)
signal on_save_gameplay_data(game_data_resource : SavefileDataResource)
signal on_load_gameplay_data(game_data_resource : SavefileDataResource)
signal on_clear_gameplay_data

var save_files : Array[SavefileDataResource]
var current_save_file_index : int = 0

func _ready() -> void:
	if (check_for_existing_data() == false):
		current_save_file_index = 0
	
	preload_savefiles()
	get_current_save_file_on_load()


func preload_savefiles() -> void:
	if (DirAccess.dir_exists_absolute("user://saves")):
		var dir = DirAccess.open("user://saves")
		var amount = dir.get_files().size()
		
		for index in amount:
			save_files.push_back(load_savefile_data(index))

func get_current_save_file_on_load() -> void:
	if (FileAccess.file_exists("user://game_data.txt")):
		var file = FileAccess.open("user://game_data.txt", FileAccess.READ)
		var game_data_dictionary = file.get_var()
		
		var loaded_game_data : GameDataResource = GameDataResource.new()
		loaded_game_data.dictionary_to_game_data(game_data_dictionary)
		
		current_save_file_index = loaded_game_data.LAST_SAVE_DATA_INDEX
		
	else:
		var file = FileAccess.open("user://game_data.txt", FileAccess.WRITE)
		var new_game_data : GameDataResource = GameDataResource.new()
		file.store_var(new_game_data.game_data_to_dictionary())
		current_save_file_index = 0

func check_for_existing_data() -> bool:
	if (DirAccess.dir_exists_absolute("user://saves") == false):
		DirAccess.make_dir_absolute("user://saves")
		generate_savefile_data()
		return false
	else:
		if (DirAccess.open("user://saves").get_files().size() == 0):
			generate_savefile_data()
			return false
	
	return true

func generate_savefile_data() -> void:
	var dir = DirAccess.open("user://saves")
	var amount = dir.get_files().size()
	
	var file = FileAccess.open("user://saves/save_game_" + str(amount) + ".txt", FileAccess.WRITE)
	
	var save_dictionary = create_new_savefile_data()
	file.store_var(save_dictionary)
	
	var savefile_data : SavefileDataResource = SavefileDataResource.new()
	savefile_data.dictionary_to_game_data(save_dictionary)
	save_files.push_back(savefile_data)
	
	on_generate_new_gameplay_save_data.emit(savefile_data)

func create_new_savefile_data() -> Dictionary:
	
	var new_data = SavefileDataResource.new()
	var dictionary = new_data.game_data_to_dictionary()
	
	return dictionary

func save_savefile_data(index : int = 0) -> void:
	var file_path = "user://saves/save_game_" + str(index) + ".txt"
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_var(save_files[index].game_data_to_dictionary())
	on_save_gameplay_data.emit(save_files[index])

#func load_current_gameplay_data() -> GameplayDataResource:
	#return load_savefile_data(current_save_file_index)

func load_savefile_data(index : int = 0) -> SavefileDataResource:
	var file_path = "user://saves/save_game_" + str(index) + ".txt"
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var dictionary : Dictionary = file.get_var()
	
	var game_data : SavefileDataResource = SavefileDataResource.new()
	game_data.dictionary_to_game_data(dictionary)
	
	on_load_gameplay_data.emit(game_data)
	
	return game_data

func get_current_savefile_data() -> SavefileDataResource:
	return save_files[current_save_file_index]

func overwrite_current_savefile_data_values(key : String, value, do_save : bool) -> void:
	var dictionary : Dictionary = save_files[current_save_file_index].game_data_to_dictionary()
	if (dictionary.has(key) == false):
		push_warning("That's not an existing value")
		return
	
	dictionary.set(key, value)
	save_files[current_save_file_index].dictionary_to_game_data(dictionary)
	
	if (do_save): save_savefile_data(current_save_file_index)

func overwrite_savefile_data_values(index : int, key : String, value, do_save : bool) -> void:
	var dictionary : Dictionary = save_files[index].game_data_to_dictionary()
	if (dictionary.has(key) == false):
		push_warning("That's not an existing value")
		return
	
	dictionary.set(key, value)
	save_files[current_save_file_index].dictionary_to_game_data(dictionary)
	
	if (do_save): save_savefile_data(current_save_file_index)

func clear_savefile_data(index : int) -> void:
	save_files[index] = SavefileDataResource.new()
	save_savefile_data(index)
	on_clear_gameplay_data.emit()
