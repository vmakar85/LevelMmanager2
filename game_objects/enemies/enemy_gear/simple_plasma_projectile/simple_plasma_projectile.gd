extends CharacterBody2D

var damage: int = 10
var bullet_vector : Vector2 = Vector2(0,-1)
@export var speed : float = 200
@onready var area : Area2D = $EnemyBullet

func _ready() -> void:
	area.add_to_group("enemy_bullets")

func _physics_process(delta: float) -> void:
	global_position += bullet_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func qf() -> void: 
	queue_free()
