extends Resource
class_name PowerupMappingResource

@export var key: String = "A"
@export var enemy_id: String = "0"
@export var powerup: PowerupResource



## Как это работает 
## берем наш enum в PowerupResource.PowerupType получаем 
## .keys() и извлекаем из него текущий powerup.type см.выше
func get_powerup_name() -> String:
	return str(PowerupResource.PowerupType.keys()[powerup.type])
