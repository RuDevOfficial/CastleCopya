extends Node2D
class_name Whipable
# Base class that lets an object be whipped
# Drops "drops" from a list

@export var consumable_list : Array[Drop]
@export var particle_scene : PackedScene
var particle_pivot : Node2D

@onready var random : RandomNumberGenerator = RandomNumberGenerator.new()

@onready var area2D : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite
@onready var break_sound : FmodEventEmitter2D = $BreakSound

@export var sound_key : String

var object_hidden : bool = false

func _ready() -> void:
	particle_pivot = get_node("ParticleSpawnPivot")
	
	if (particle_pivot == null):
		var new_pivot : Node2D = Node2D.new()
		new_pivot.name = "ParticleSpawnPivot"
		particle_pivot = new_pivot
		add_child(new_pivot)
	
	SignalBus.on_level_fade_completed.connect(show_object)

func _on_area_entered(area: Area2D) -> void:
	if (object_hidden): return
	
	drop_new_object()
	generate_sound()
	spawn_particle()
	hide_object()

func drop_new_object() -> void:
	if (consumable_list.size() == 0): return
	
	var packed_consumable = return_random_consumable_by_weight()
	var spawned_consumable : Node2D = null
	
	if (packed_consumable == null): spawned_consumable = consumable_list[0].object.instantiate()
	else: spawned_consumable = packed_consumable.instantiate()
	
	spawned_consumable.global_position = particle_pivot.global_position
	get_parent().add_child(spawned_consumable)

func return_random_consumable_by_weight() -> PackedScene:
	
	var selected_consumable : PackedScene = null
	
	for consumable in consumable_list:
		var random_number = random.randf_range(0.00, 100.00)
		if (random_number <= consumable.weight):
			selected_consumable = consumable.object
			break
	
	return selected_consumable

func spawn_particle() -> void:
	var particle = particle_scene.instantiate()
	particle.global_position = particle_pivot.global_position
	get_tree().root.add_child(particle)

func generate_sound() -> void:
	AudioManager.do_one_shot(sound_key)

func show_object() -> void:
	object_hidden = false
	
	area2D.monitorable = true
	area2D.monitoring = true
	
	sprite.visible = true
	
	additional_show_object() # OVERWRITTABLE (see block_whippable.gd)


func hide_object() -> void:
	
	object_hidden = true
	
	area2D.monitorable = false
	area2D.monitoring = false
	
	sprite.visible = false
	
	additional_hide_object() # OVERWRITTABLE (see block_whippable.gd)

func additional_show_object() -> void: pass
func additional_hide_object() -> void: pass
