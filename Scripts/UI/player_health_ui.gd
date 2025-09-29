extends Control
class_name PlayerHealthUIManager

@export var player_resource : PlayerResource
@export var bar_scene : PackedScene

@export var empty_bar_texture : CompressedTexture2D
@export var full_bar_texture : CompressedTexture2D

@onready var horizontal_container : HBoxContainer = $HBoxContainer

var bar_list : Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_level_generated.connect(level_loaded_add_bars)
	
	SignalBus.on_player_take_damage.connect(player_damage_override_bar_status)
	SignalBus.on_player_death.connect(death_override_all_bars)
	
	SignalBus.on_middle_transition.connect(func(is_player_respawning):
		if (is_player_respawning == true): scene_switcher_fade_complete())

func level_loaded_add_bars(level_resource : LevelResource, level_instance : Node2D) -> void:
	add_max_bars(player_resource.StartingHealth)

func player_damage_override_bar_status(max_health : int, current : int) -> void:
	update_bar_state(max_health, current)

func death_override_all_bars() -> void:
	update_bar_state(bar_list.size(), 0)

func scene_switcher_fade_complete() -> void:
	update_bar_state(bar_list.size(), bar_list.size())

func add_max_bars(amount : int) -> void:
	for i in amount:
		var new_bar : TextureRect = bar_scene.instantiate()
		horizontal_container.add_child(new_bar)
		bar_list.push_back(new_bar)

func update_bar_state(max, current : int) -> void:
	for i in range(max - 1, -1, -1):
		if (i > current - 1): bar_list[i].texture = empty_bar_texture
		else: bar_list[i].texture = full_bar_texture
