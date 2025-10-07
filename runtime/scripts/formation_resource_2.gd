## FormationResource2 v3 
#LevelResource2 (Resource)
#	└── FormationResource2 (Resource)
#			├─ level_name (String)
#			├─ ascii_layout (Array[String])
#			├─ movement_speed
#			├─ shift_down_speed
#			├─ start_y 
#			└─ enemy_overrides (Array[EnemyOverrideResource])
#					├─ enemy_id (String) 
#					├─ enemy_overrided_id (String) 
#					├─ health (int)
#					├─ points (int)
#					├─ self_name (String)            
#					└─ powerup (PowerupResource)
#						  ├─ type  (PowerupType)
#						  ├─ icon  (Texture2D)
#						  └─ scene (PackedScene)

class_name FormationResource2
extends Resource

## Ресурс описывает формацию врагов для уровня

# Название уровня
@export var level_name: String = "Level test"

# ASCII-представление формации врагов.
# '*'   - пустая ячейка
# '0'..'8' - базовый враг (индекс в enemy_scenes)
# Пример: ["****1****", "123*123", "*1*"]
@export var ascii_layout: Array[String] = ["*"]

# Скорости и стартовая позиция
@export var movement_speed: float = 50.0
@export var shift_down_speed: float = 20.0
@export var start_y: float = 100.0

# Переопределения врагов (hp, очки, powerup и т.п.)
@export var enemy_overrides: Array[EnemyOverrideResource] = []

# --- Вспомогательная структура ---
class Cell:
	var type: int = -1           # enemy id (0–8), -1 если пустая
	var override_key: String = "" # буква, если враг переопределён

# --- Основные методы ---
func parse_ascii() -> Array:
	## Преобразует ascii_layout в сетку Cell
	var grid: Array = []
	for row in ascii_layout:
		var row_data: Array = []
		for chr in row:
			var cell = Cell.new()
			if chr == "*":
				cell.type = -1
			elif chr.is_valid_int():
				# это базовый id врага
				cell.type = int(chr)
				cell.override_key = ""
			elif chr.is_valid_identifier() and chr.length() == 1:
				# это override (буква)
				cell.type = -2  # спец. маркер
				cell.override_key = chr
			else:
				cell.type = -1
			row_data.append(cell)
		grid.append(row_data)
	return grid

func get_override(enemy_id: String) -> EnemyOverrideResource:
	## Находит оверрайд для врага по его id
	for ov in enemy_overrides:
		if ov.enemy_id == enemy_id:
			return ov
	return null

#region Методы для редактора
func add_row() -> void:
	ascii_layout.append("")
	emit_changed()

func add_row_filled(length: int, fill_char: String = "*") -> void:
	if length <= 0:
		length = 1
	ascii_layout.append(fill_char.repeat(length))
	emit_changed()

func remove_row(row_index: int) -> void:
	if row_index >= 0 and row_index < ascii_layout.size():
		ascii_layout.remove_at(row_index)
		emit_changed()

func add_cell_to_row(row_index: int, symbol: String = "*") -> void:
	if row_index < 0 or row_index >= ascii_layout.size():
		return
	ascii_layout[row_index] += symbol
	emit_changed()

func remove_cell_from_row(row_index: int) -> void:
	if row_index < 0 or row_index >= ascii_layout.size():
		return
	if ascii_layout[row_index].length() > 0:
		var chars = ascii_layout[row_index].to_utf8_buffer()
		chars.resize(chars.size() - 1)
		ascii_layout[row_index] = ""
		for c in chars:
			ascii_layout[row_index] += String.chr(c)
		emit_changed()

func set_cell(row_index: int, col_index: int, symbol: String) -> void:
	if row_index < 0 or row_index >= ascii_layout.size():
		return
	if col_index < 0 or col_index >= ascii_layout[row_index].length():
		return

	var row_chars = ascii_layout[row_index].to_utf8_buffer()
	row_chars[col_index] = symbol.unicode_at(0)
	ascii_layout[row_index] = ""
	for chr in row_chars:
		ascii_layout[row_index] += String.chr(chr)
	emit_changed()

func get_cell(row_index: int, col_index: int) -> String:
	if row_index < 0 or row_index >= ascii_layout.size():
		return ""
	if col_index < 0 or col_index >= ascii_layout[row_index].length():
		return ""
	return ascii_layout[row_index][col_index]

func get_max_row_length() -> int:
	var max_len = 0
	for row in ascii_layout:
		if row.length() > max_len:
			max_len = row.length()
	return max_len

func get_override_by_key(key: String) -> EnemyOverrideResource:
	## Находит override по символу (A, B, ...)
	for ov in enemy_overrides:
		if ov.enemy_overrided_id == key:
			return ov
	return null

func get_overrides_by_key(key: String) -> Array[EnemyOverrideResource]:
	var overrides: Array[EnemyOverrideResource] = []
	for ov in enemy_overrides:
		if ov.enemy_id == key:
			overrides.append(ov)
	return overrides

func delete_overrides_by_key(key: String) -> Array[EnemyOverrideResource]:
	var overrides: Array[EnemyOverrideResource] = []
	for ov in enemy_overrides:
		if ov.enemy_overrided_id != key:
			overrides.append(ov)
	enemy_overrides = overrides
	return enemy_overrides  

#endregion
