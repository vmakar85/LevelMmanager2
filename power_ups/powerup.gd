extends CharacterBody2D
class_name PowerUp

var self_vector : Vector2 = Vector2.DOWN
@export var speed : float = 100


func _physics_process(delta: float) -> void:
	global_position += self_vector.rotated(rotation) * speed * delta
