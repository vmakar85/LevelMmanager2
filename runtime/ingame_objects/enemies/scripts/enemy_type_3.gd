extends Enemy

var damage: int = 25
@onready var cpu_particles_2d: GPUParticles2D = $CPUParticles2D

func emittig_fire() -> void:
	cpu_particles_2d.emitting = !cpu_particles_2d.emitting
