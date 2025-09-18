@tool

extends Node
class_name MusicManager

var music_emitter : FmodEventEmitter2D
@export var music_dictionary : Dictionary[String, String]

var music_stopped : bool = true

func _ready() -> void:
	generate_event_dictionary()
	
	music_emitter = FmodEventEmitter2D.new()
	add_child(music_emitter)

func play_music(key : String) -> bool:
	var result : bool = music_dictionary.has(key)
	if (result == false): return false
	
	var next_guid : String = music_dictionary.get(key)
	if (music_emitter.event_guid != next_guid || music_stopped == true):
		music_emitter.stop()
		music_emitter.event_guid = next_guid
		music_emitter.play()
		music_stopped = false
	
	return true

func stop_music(allow_fadeout : bool) -> void:
	music_emitter.allow_fadeout = allow_fadeout
	music_emitter.stop()
	music_stopped = true

func overwrite_volume(new_volume : float) -> void:
	music_emitter.volume = clampf(new_volume, 0.00, 1.00)

func generate_event_dictionary():
	
	music_dictionary.clear()
	
	var bank : FmodBank = FmodServer.load_bank("res://Banks/Desktop/MUSIC.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	for item : FmodEventDescription in bank.get_description_list():
		var eventPath : String = FmodServer.get_event_path(item.get_guid())
		var string : PackedStringArray = eventPath.split("/")
		#print(string)
		#music_dictionary.get_or_add(string[1], item.get_guid())
	
	music_dictionary.sort()
