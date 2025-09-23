extends Enemy

var damage: int = 25
@onready var cpu_particles_2d: GPUParticles2D = $CPUParticles2D
@onready var light: PointLight2D = $PointLight2D

func worning_light() -> void:
	light.visible = !light.visible
	
func emittig_fire() -> void:
	cpu_particles_2d.emitting = !cpu_particles_2d.emitting
