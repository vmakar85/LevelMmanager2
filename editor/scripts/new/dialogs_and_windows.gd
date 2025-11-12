extends Node
# Используем @export для назначения окон в инспекторе
@export var enemies_editor_container: Control
@export var formation_editor_container: Control
@export var current_active_window: Control = null

# Перечисление для состояний (имен окон)
enum WindowState {
	NONE,
	ENEMIES_EDITOR,
	FORMATION_EDITOR
}

func _ready():
	# Скрываем все окна при старте, если они не скрыты в редакторе
	enemies_editor_container.visible = false
	formation_editor_container.visible = false
	current_active_window = null

	# Можно подключить обработчик сигнала Esc здесь, в менеджере,
	# чтобы закрывать текущее активное окно.
	# Input.set_use_accumulated_input_for_ui(false) # Убедитесь, что ввод обрабатывается корректно

func switch_to_window(target_state: WindowState, data: Dictionary = {}):
	var target_window: Control = null
	var target_window_name: String = ""

	match target_state:
		WindowState.ENEMIES_EDITOR:
			target_window = enemies_editor_container
			target_window_name = "enemies_editor"
		WindowState.FORMATION_EDITOR:
			target_window = formation_editor_container
			target_window_name = "formation_editor"
		WindowState.NONE:
			# Если NONE, просто закрываем текущее окно
			pass

	# Скрываем текущее активное окно, если оно есть
	if current_active_window != null:
		current_active_window.visible = false
		# Опционально: вызвать метод popdown() в скрипте окна
		if current_active_window.has_method("popdown"):
			current_active_window.popdown()

	# Показываем новое окно, если оно задано
	if target_window != null:
		target_window.visible = true
		current_active_window = target_window
		print('[Window Manager] Switched to: ' + target_window_name)

		# Опционально: вызвать метод popup() в скрипте окна и передать данные
		if target_window.has_method("popup"):
			target_window.popup(data) # передаем данные, если нужно
	else:
		current_active_window = null


# Обработка Escape для закрытия текущего окна
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and current_active_window != null:
		print("Esc нажат. Закрываем " + current_active_window.name)
		switch_to_window(WindowState.NONE)
