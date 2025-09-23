extends Node2D
@onready var p: = $GPUParticles2D
@onready var p2: = $GPUParticles2D2
func _ready() -> void:
	p2.emitting = true
	p.emitting = true

func _on_gpu_particles_2d_finished() -> void:
	queue_free()
