extends Node2D

@onready var particle : GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	particle.emitting = true

func _on_event_finished() -> void:
	self.queue_free()
