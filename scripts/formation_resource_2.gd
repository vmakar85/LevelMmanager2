class_name FormationResource2 extends Resource
## FormationResource2 v2 
## TODO
## Название уровня, отображается в интерфейсе редактора и, возможно, в игре
@export var level_name: String = "Level test"

## ASCII-представление формации врагов.
## Символы:
##   '*' - пустая ячейка
##   '0'..'8' - обычный враг (индекс соответствует enemy_scenes)
##   'A'..'Z' - специальный враг с powerup (смотри powerup_mapping)
## Каждая строка массива - это ряд врагов.
## Пример: ["****1****", "123*123", "*1*"] - рваная формация
@export var ascii_layout: Array[String] = ["*"]

## Базовая скорость горизонтального движения формации (пикселей в секунду)
@export var movement_speed: float = 50.0

## Скорость смещения формации вниз после достижения границы (пикселей за шаг)
@export var shift_down_speed: float = 20.0

## Стартовая позиция формации по вертикали (Y-координата)
@export var start_y: float = 100.0

@export var enemy_overrides: Array[EnemyOverrideResource] = []
@export var powerup_mapping: Array[PowerupMappingResource] = []

# структура ячейки
class Cell:
	var type: int = -1 # enemy id (0–8), -1 если пустая
	var powerup: String

func parse_ascii() -> Array:
	var grid: Array = []
	for row in ascii_layout:
		var row_data: Array = []
		for chr in row:
			var cell = Cell.new()
			if chr == "*":
				cell.type = -1
			elif chr.is_valid_int():
				cell.type = int(chr)
			elif chr.is_valid_ascii_identifier():
				var mapping := get_powerup_mapping(chr)
				if mapping != null:
					cell.type = mapping.enemy_id
					cell.powerup = mapping.powerup
				else:
					cell.type = -1 # если в ascii_layout есть буква, но нет маппинга
			else:
				cell.type = -1
			row_data.append(cell)
		grid.append(row_data)
	return grid

func get_override(enemy_id: String) -> EnemyOverrideResource:
	for ov in enemy_overrides:
		if ov.enemy_id == enemy_id:
			return ov
	return null

func get_powerup_mapping(symbol: String) -> PowerupMappingResource:
	for pm in powerup_mapping:
		if pm.symbol == symbol:
			return pm
	return null

func get_enemy_override(enemy_id: String) -> EnemyOverrideResource:
	# Находит оверрайд для врага по его ID
	for override in enemy_overrides:
		if override.enemy_id == enemy_id:
			return override
	return null


func get_powerup_by_key(key: String) -> PowerupMappingResource:
	# Находит powerup по букве из ascii_layout
	for mapping in powerup_mapping:
		if mapping.key == key:
			return mapping
	return null


func get_powerups_for_enemy(enemy_id: String) -> Array[PowerupMappingResource]:
	# Собирает все powerup'ы, связанные с конкретным enemy_id
	var result: Array[PowerupMappingResource] = []
	for mapping in powerup_mapping:
		if mapping.enemy_id == enemy_id:
			result.append(mapping)
	return result


#region editor only
# Добавляет новый ПУСТОЙ ряд в конец
func add_row() -> void:
	ascii_layout.append("") # Просто добавляем пустую строку
	emit_changed()

# Добавляет новый ряд, заполненный символами, в конец
func add_row_filled(length: int, fill_char: String = "*") -> void:
	if length <= 0:
		length = 1 # Минимум один символ
	ascii_layout.append(fill_char.repeat(length))
	emit_changed()

# Удаляет ряд по индексу
func remove_row(row_index: int) -> void:
	if row_index >= 0 and row_index < ascii_layout.size():
		ascii_layout.remove_at(row_index)
		emit_changed()

# Добавляет колонку ТОЛЬКО к ОДНОЙ конкрентной строке
func add_cell_to_row(row_index: int, symbol: String = "*") -> void:
	if row_index < 0 or row_index >= ascii_layout.size():
		return
	ascii_layout[row_index] += symbol
	emit_changed()

# Удаляет последний символ ИЗ КОНКРЕТНОЙ строки
func remove_cell_from_row(row_index: int) -> void:
	if row_index < 0 or row_index >= ascii_layout.size():
		return
	if ascii_layout[row_index].length() > 0:
		# Преобразуем в массив, удаляем последний элемент, собираем обратно
		var chars = ascii_layout[row_index].to_utf8_buffer()
		chars.resize(chars.size() - 1)
		ascii_layout[row_index] = ""
		for c in chars:
			ascii_layout[row_index] += String.chr(c)
		emit_changed()

# Изменяет символ в конкретной ячейке (ОСНОВНОЙ МЕТОД)
func set_cell(row_index: int, col_index: int, symbol: String) -> void:
	if row_index < 0 or row_index >= ascii_layout.size():
		return
	if col_index < 0 or col_index >= ascii_layout[row_index].length():
		return # Важно: не выравниваем автоматически!

	var row_chars = ascii_layout[row_index].to_utf8_buffer()
	row_chars[col_index] = symbol.unicode_at(0)
	ascii_layout[row_index] = ""
	for chr in row_chars:
		ascii_layout[row_index] += String.chr(chr)
	emit_changed()

# Возвращает символ из ячейки
func get_cell(row_index: int, col_index: int) -> String:
	if row_index < 0 or row_index >= ascii_layout.size():
		return ""
	if col_index < 0 or col_index >= ascii_layout[row_index].length():
		return ""
	return ascii_layout[row_index][col_index]

# Вспомогательный метод: возвращает длину самой длинной строки (для отрисовки UI)
func get_max_row_length() -> int:
	var max_len = 0
	for row in ascii_layout:
		if row.length() > max_len:
			max_len = row.length()
	return max_len
#endregion
