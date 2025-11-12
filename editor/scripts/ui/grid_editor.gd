extends MarginContainer

@onready var grid_container: GridContainer = %GridContainer
@onready var row_controls_container: VBoxContainer = %RowControlsContainer # Новый контейнер!

var formation_res: FormationResource
var selected_symbol: String = "0"
var active_level: LevelResource


func _ready():
	# Подключаем кнопки управления
	%AddRowButton.pressed.connect(_on_add_row_button_pressed)
	%AddFilledRowButton.pressed.connect(_on_add_filled_row_button_pressed) # Новая кнопка
	%RefreshButton.pressed.connect(_on_refresh_button_pressed)
	#UiSignalBus.formation_updated.connect(_on_formation_updated)
	# Инициализируем палитру символов, если она есть
	UiSignalBus.symbol_selected.connect(_on_symbol_selected)
	UiSignalBus.level_updated.connect(_on_level_updated)


func setup(formation: FormationResource):
	formation_res = formation
#	UiSignalBus.emit_refresh_formation(formation_res)
	_update(formation_res)


func _update(formation: FormationResource):
	# Очищаем ВСЁ
	for child in grid_container.get_children():
		child.queue_free()
	for child in row_controls_container.get_children():
		child.queue_free()
	if not formation_res:
		return
	# 1. Устанавливаем количество колонок по самой длинной строке
	grid_container.columns = formation_res.get_max_row_length()
	# 2. Создаем UI для КАЖДОЙ строки отдельно
	for row_idx in formation_res.ascii_layout.size():
		_create_row_ui(row_idx)
	# 3. устанавливаем дополнительные символы если такие имеются 
	_update_extended_symbols_container(formation)


func _update_extended_symbols_container(formation: FormationResource):
	if formation.enemy_overrides.size() > 0:
		UiSignalBus.emit_extended_symbol_add(formation.enemy_overrides)


func _create_row_ui(row_index: int):
	var row_hbox = HBoxContainer.new()
	row_controls_container.add_child(row_hbox)
	# Кнопка удаления этой строки
	var delete_row_btn = Button.new()
	delete_row_btn.text = "X"
	delete_row_btn.custom_minimum_size = Vector2(30, 30)
	delete_row_btn.pressed.connect(_on_delete_row_pressed.bind(row_index))
	row_hbox.add_child(delete_row_btn)
	# Кнопка добавления ячейки В ЭТУ строку
	var add_cell_btn = Button.new()
	add_cell_btn.text = "+"
	add_cell_btn.custom_minimum_size = Vector2(30, 30)
	add_cell_btn.pressed.connect(_on_add_cell_pressed.bind(row_index))
	row_hbox.add_child(add_cell_btn)
	# Кнопка удаления ячейки ИЗ ЭТОЙ строки
	var remove_cell_btn = Button.new()
	remove_cell_btn.text = "-"
	remove_cell_btn.custom_minimum_size = Vector2(30, 30)
	remove_cell_btn.pressed.connect(_on_remove_cell_pressed.bind(row_index))
	row_hbox.add_child(remove_cell_btn)
	# Label с номером строки
	var row_label = Label.new()
	row_label.text = "Row: " + str(row_index)
	row_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row_hbox.add_child(row_label)
	# Сами ячейки этой строки
	var current_row = formation_res.ascii_layout[row_index]
	for col_idx in current_row.length():
		var cell_button = Button.new()
		var cell_symbol = formation_res.get_cell(row_index, col_idx)
		cell_button.text = cell_symbol
		cell_button.custom_minimum_size = Vector2(30, 30)
		cell_button.pressed.connect(_make_cell_callback(row_index, col_idx))
		grid_container.add_child(cell_button)
	# Заполняем оставшиеся ячейки пустыми (для выравнивания в GridContainer)
	var empty_cells_count = formation_res.get_max_row_length() - current_row.length()
	for i in empty_cells_count:
		var empty_control = Control.new()
		empty_control.custom_minimum_size = Vector2(30, 30)
		grid_container.add_child(empty_control)


func _on_add_row_button_pressed():
	if formation_res:
		if formation_res.ascii_layout.size() <= 4:
			formation_res.add_row() # Добавляем пустую строку
			_update(formation_res)


func _on_add_filled_row_button_pressed():
	if formation_res:
		if formation_res.ascii_layout.size() <= 4:
		# Запрашиваем длину новой строки (можно через диалог или просто задать 5)
			var new_length = 5 # или %LengthSpinBox.value
			formation_res.add_row_filled(new_length)
			_update(formation_res)


func _on_delete_row_pressed(row_index: int):
	if formation_res:
		formation_res.remove_row(row_index)
		_update(formation_res)


func _on_add_cell_pressed(row_index: int):
	if formation_res:
		formation_res.add_cell_to_row(row_index, "*") # Добавляем пустую ячейку
		_update(formation_res)


func _on_remove_cell_pressed(row_index: int):
	if formation_res:
		formation_res.remove_cell_from_row(row_index)
		_update(formation_res)


func _make_cell_callback(row: int, col: int) -> Callable:
	return func():
		if formation_res:
			formation_res.set_cell(row, col, selected_symbol)
			_update(formation_res)


func _on_symbol_selected(symbol: String):
	selected_symbol = symbol


func _on_refresh_button_pressed():
	active_level.formation = formation_res
	UiSignalBus.emit_level_updated(active_level)
	_update(formation_res)


func _on_draw() -> void:
	active_level.formation = formation_res
	UiSignalBus.emit_level_updated(active_level)
	_update(formation_res)


func popup(_data: Dictionary = {}): 
	UiSignalBus.emit_active_window_notifier('formation_editor')


func _on_formation_updated(formation_resource: FormationResource):
	setup(formation_resource)


func popdown():
	pass


func _on_level_updated(level: LevelResource):
	setup(level.formation)
	active_level = level
