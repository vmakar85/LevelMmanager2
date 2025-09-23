extends Node2D

@onready var area: Area2D = $EnemyBullet
var hp:int = 20


func _ready() -> void:
	area.add_to_group("enemy_bullets")


func qf() -> void: 
	hp -= 10
	
func _physics_process(_delta: float) -> void:
	if hp <= 0: 
		queue_free()
