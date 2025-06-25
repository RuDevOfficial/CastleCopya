@tool

extends Node
class_name SFXManager

@export var sound_dictionary : Dictionary[String, String]

func _ready() -> void:
	generate_event_dictionary()

func do_one_shot(key : String) -> bool:
	var result : bool = sound_dictionary.has(key)
	if (result == false): return false
	
	var event_emitter = FmodEventEmitter2D.new()
	event_emitter.autoplay = true;
	event_emitter.event_guid = sound_dictionary.get(key)
	event_emitter.play()
	return true

func generate_event_dictionary():
	
	sound_dictionary.clear()
	
	var bank : FmodBank = FmodServer.load_bank("res://FmodBank/Desktop/SFX.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL)
	for item : FmodEventDescription in bank.get_description_list():
		var eventPath : String = FmodServer.get_event_path(item.get_guid())
		var string : PackedStringArray = eventPath.split("/")
		sound_dictionary.get_or_add(string[1], item.get_guid())
	
	sound_dictionary.sort()
