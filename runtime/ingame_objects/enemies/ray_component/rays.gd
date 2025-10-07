extends Node2D


@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight

func _physics_process(_delta: float) -> void:
	if ray_left.is_colliding() or ray_right.is_colliding():
		var r_collider: Node2D = ray_right.get_collider()
		var l_collider: Node2D = ray_left.get_collider()
		if r_collider or l_collider:
			SignalBus.emit_switch_direction_request()
