extends Node2D
class_name Subweapon
# Base class, it's affected by modifiers applied via composition instead of inheritance

@export var Modifiers : Array[SubweaponModifierResource]
@export var Subweapon_Resource : SubweaponResource
@onready var Sprite : Sprite2D = $Sprite

var current_time : float = 0.0
var lifetime_reached : bool = false

var sound_emitter : FmodEventEmitter2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Subweapon_Resource.Initialize(self)
	sound_emitter = AudioManager.attach_one_shot(Subweapon_Resource.SoundKey, self)
	
	for modifier in Modifiers:
		modifier.Modify(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (lifetime_reached == true): return
	
	for modifier in Modifiers:
		modifier.Update(delta)
	
	if (current_time < Subweapon_Resource.Lifetime): current_time += delta
	elif (current_time >= Subweapon_Resource.Lifetime and lifetime_reached == false):
		lifetime_reached = true
		on_lifetime_reached()

func _physics_process(delta: float) -> void:
	if (lifetime_reached == true): return
	
	for modifier in Modifiers:
		modifier.PhysicsUpdate(delta)

func _on_area_entered(area: Area2D) -> void:
	if (lifetime_reached == true): return
	
	for modifier in Modifiers:
		modifier.OnContact(area)

func on_lifetime_reached() -> void:
	lifetime_reached = true
	for modifier in Modifiers:
		modifier.OnLifetimeReached()
	
	if (AudioManager.does_sound_exist(Subweapon_Resource.SoundKey)): sound_emitter.stop()
	queue_free()

func throw(throw_direction : Vector2) -> void:
	Subweapon_Resource.Direction = throw_direction
	for modifier in Modifiers:
		modifier.OnThrown(throw_direction)
