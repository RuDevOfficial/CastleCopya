extends Node
class_name SaveGameManager

func check_for_existing_data() -> void:
	if (DirAccess.dir_exists_absolute("user://saves") == false):
		DirAccess.make_dir_absolute("user://saves")
		generate_save_data()
	else:
		if (DirAccess.open("user://saves").get_files().size() == 0):
			generate_save_data()

func generate_save_data() -> void:
	var dir = DirAccess.open("user://saves")
	var amount = dir.get_files().size()
	
	var file = FileAccess.open("user://saves/save_game_" + str(amount) + ".dat", FileAccess.WRITE)
	file.store_var(create_new_save_data())

func create_new_save_data() -> Dictionary:
	
	var new_data = GameDataResource.new()
	var dictionary = new_data.game_data_to_dictionary()
	
	return dictionary

func save_data(game_data_resource : GameDataResource, index : int = 0) -> void:
	var file_path = "user://saves/save_game_" + str(index) + ".dat"
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_var(game_data_resource.game_data_to_dictionary())

func load_data(index : int = 0) -> GameDataResource:
	var file_path = "user://saves/save_game_" + str(index) + ".dat"
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var dictionary : Dictionary = file.get_var()
	
	var game_data : GameDataResource = GameDataResource.new()
	game_data.dictionary_to_game_data(dictionary)
	
	return game_data
