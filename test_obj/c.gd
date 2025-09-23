extends Node2D
var anchor:Node2D
var power_up

func _ready() -> void:
	# добавляем в глобальную группу 
	add_to_group("enemies")
	
func _process(delta: float) -> void:
	global_position = anchor.global_position
