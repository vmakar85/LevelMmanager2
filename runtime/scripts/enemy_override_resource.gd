extends Resource
class_name EnemyOverrideResource

@export var enemy_id: String = "0"
@export var enemy_overrided_id: String = "A"
@export var health: int = -1
@export var points: int = -1
@export var self_name: String = ""
@export var powerup: PowerupResource

func get_health() -> int:
	return health

func get_points() -> int:
	return points

func get_enemy_id() -> String:
	return enemy_id

func get_self_name() -> String:
	return self_name 

func get_enemy_overrided_id() -> String:
	return enemy_overrided_id

## Как это работает 
## берем наш enum в PowerupResource.PowerupType получаем 
## .keys() и извлекаем из него текущий powerup.type см.выше
func get_powerup_name() -> String:
	if powerup == null:
		return "EMPTY"
	return str(PowerupResource.PowerupType.keys()[powerup.type])
