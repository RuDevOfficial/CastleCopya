extends Node

var music_emitter : FmodEventEmitter2D
var music_stopped : bool = true

var music_dictionary : Dictionary[String, String]
@export var sound_dictionary : Dictionary[String, String]

func _ready() -> void:
	music_emitter = FmodEventEmitter2D.new()
	add_child(music_emitter)
	
	FmodServer.load_bank("res://Banks/Desktop/Master.strings.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	FmodServer.load_bank("res://Banks/Desktop/Master.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	
	generate_music_event_dictionary()
	generate_event_dictionary()

#region MUSIC

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

func generate_music_event_dictionary():
	
	music_dictionary.clear()
	
	var bank : FmodBank = FmodServer.load_bank("res://Banks/Desktop/MUSIC.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	for item : FmodEventDescription in bank.get_description_list():
		var eventPath : String = FmodServer.get_event_path(item.get_guid())
		var string : PackedStringArray = eventPath.split("/")
		music_dictionary.get_or_add(string[string.size() - 1], item.get_guid())
	
	music_dictionary.sort()

#endregion

#region SOUND

func do_one_shot(key : String) -> bool:
	var result : bool = sound_dictionary.has(key)
	if (result == false): return false
	
	var event_emitter = FmodEventEmitter2D.new()
	event_emitter.event_guid = sound_dictionary.get(key)
	event_emitter.play()
	return true

func attach_one_shot(key : String, node : Node2D) -> FmodEventEmitter2D:
	var result : bool = sound_dictionary.has(key)
	if (result == false): return null
	
	var emitter : FmodEventEmitter2D = FmodEventEmitter2D.new()
	node.add_child(emitter)
	emitter.allow_fadeout = true
	emitter.attached = true
	emitter.event_guid = sound_dictionary.get(key)
	emitter.play()
	
	return emitter

func generate_event_dictionary():
	
	sound_dictionary.clear()
	
	var bank : FmodBank = FmodServer.load_bank("res://Banks/Desktop/SFX.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	for item : FmodEventDescription in bank.get_description_list():
		var eventPath : String = FmodServer.get_event_path(item.get_guid())
		var string : PackedStringArray = eventPath.split("/")
		sound_dictionary.get_or_add(string[string.size() - 1], item.get_guid())
	
	sound_dictionary.sort()
	
	#endregion

func does_sound_exist(name : String) -> bool:
	return sound_dictionary.has(name)
