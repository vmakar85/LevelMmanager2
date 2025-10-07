class_name LevelManager2
extends Node2D

# --- Настройки ---
@export var enemy_size: float = 64.0
@export var enemy_offset: float = 10.0
var enemy_scenes: = Resources.enemy_scenes

# --- Текущее состояние ---
var current_formation: FormationResource2
var anchors: Array[Node2D] = []
var movement_direction: int = 1  # 1 = вправо, -1 = влево
var space_left: Array[float] = [] 
var current_level_index: int = 0
var levels: Array = []  # Список путей к уровням
var cooldown = false

func _ready() -> void:
	SignalBus.connect("switch_direction_request",_on_switch_direction_request)

# --- Основное ---
func load_level(index: int) -> bool:
	if index >= levels.size():
		return false  ## уровни кончились
	var level_resource: Resource = load(levels[index])
	if level_resource == null:
		push_error("Не удалось загрузить уровень: %s" % levels[index])
		return false
	# Берём formation - нам форматион нужен т.к. мы его вертим на хую (возим туда сюда)
	if !("formation" in level_resource):
		push_error("В ресурсе уровня нет formation: %s" % levels[index])
		return false
	current_formation = level_resource.formation
	_spawn_formation()
	return true

func get_current_formation_info() -> FormationResource2:
	return current_formation

func _spawn_formation() -> void:
#	Globals.player_projectile_created = 0 
#	Globals.player_projectile_faild = 0 
	_clear_formation()
	_spawn_anchors_and_enemies()

func _spawn_anchors_and_enemies() -> void:
	var viewport_width = get_viewport().get_visible_rect().size.x
	var grid = current_formation.parse_ascii()
	if grid.is_empty():
		push_error("тут пусто _spawn_anchors")
		return
	var enemies_container := get_parent().get_node_or_null("EnemiesContainer")
	if enemies_container == null:
		push_error("Не найден EnemiesContainer")
		return
	for row in range(grid.size()):
		var columns = grid[row].size()
		var row_width = columns * (enemy_size + enemy_offset)
		space_left.append(row_width) 
		var start_x = (viewport_width - row_width) / 2 + 38
		for col in range(columns):
			var cell = grid[row][col]
			var anchor := Sprite2D.new()
			anchor.texture = load("res://editor/ui/sprites/crosshair.png") 
			#anchor.scale = Vector2(0.6,0.6)
			anchor.position = Vector2(
				start_x + col * (enemy_size + enemy_offset),
				current_formation.start_y + row * (enemy_size + enemy_offset)
			)
			anchor.global_rotation_degrees = 180
			anchor.name = "Anchor_R%sC%s" % [row, col]
			## тут начинем добавлять наших врагов
			if cell.type >= 0:
				# обычный враг без override
				var enemy_scene: PackedScene = enemy_scenes.get(str(cell.type))
				var enemy = enemy_scene.instantiate()
				enemy.position = Vector2(
					start_x + col * (enemy_size + enemy_offset),
					current_formation.start_y + row * (enemy_size + enemy_offset)
				)
				enemy.global_rotation_degrees = 180
				enemy.anchor = anchor
				enemies_container.add_child(enemy)
			elif cell.type == -2 and cell.override_key != "":
				# враг с override (буква)
				var override = current_formation.get_override_by_key(cell.override_key)
				if override != null:
					var enemy_scene: PackedScene = enemy_scenes.get(override.enemy_id)
					var enemy = enemy_scene.instantiate()
					enemy.position = Vector2(
						start_x + col * (enemy_size + enemy_offset),
						current_formation.start_y + row * (enemy_size + enemy_offset)
					)
					enemy.global_rotation_degrees = 180
					# применяем параметры
					if override.health > 0:
						enemy.health = override.health
					if override.points > 0:
						enemy.points = override.points
					if override.powerup != null:
						enemy.power_up = override.get_powerup_name()
					enemy.anchor = anchor
					enemies_container.add_child(enemy)
			add_child(anchor)
			anchors.append(anchor)

func _clear_formation() -> void:
	for anchor in anchors:
		if is_instance_valid(anchor):
			anchor.queue_free()
	position = Vector2.ZERO  # сбрасываем позицию
	anchors.clear()
	space_left.clear()

func move_formation(delta: float) -> void:
	if current_formation == null or anchors.is_empty(): # --- анкоря у нас остаются (баг)
		return
	# Горизонтальное движение
	var movement = movement_direction * current_formation.movement_speed * delta
	position.x += movement

func _switch_direction_and_step_down():
	movement_direction = -movement_direction
	position.y += current_formation.shift_down_speed

func _on_switch_direction_request(): 
	if !cooldown:
		_switch_direction_and_step_down()
		cooldown = true
	await get_tree().create_timer(1.0).timeout
	cooldown = false
	
	
	
#region only for editor
##only for editor
func add_lvl_res(res : String):
	levels.append(res)

func clear_lvl_res():
	levels.clear()

func change_current_formation_movement_speed(new_speed : float):
	current_formation.movement_speed = new_speed
	pass

func change_current_down_movement_speed(new_speed : float):
	current_formation.shift_down_speed = new_speed
	pass

func update_current_fromation(form):
	current_formation = form
	_spawn_formation()

func create_level(level_resource: LevelResource2) -> bool:
	current_formation = level_resource.formation
	_spawn_formation()
	return true
#endregion
	
	
	
