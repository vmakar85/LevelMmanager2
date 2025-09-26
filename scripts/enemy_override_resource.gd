extends Resource
class_name EnemyOverrideResource

@export var enemy_id: String = "0"
@export var health: int = -1
@export var points: int = -1
@export var self_name: String = ""

func get_health() -> int:
	return health
	
func get_points() -> int:
	return points
