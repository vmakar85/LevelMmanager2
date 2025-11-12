extends Node

# --- Включи на время разработки, чтобы видеть кто что эмитит
@export var debug: bool = true

## UI - GridEditor
signal symbol_selected(symbol: String)
signal extended_symbol_add(overrides: Array[EnemyOverrideResource])
signal extended_symbol_erase(key: String)

## UI - Main (UIRoot)
signal formation_updated(current_formation : FormationResource)  
signal is_editor_ready(state : bool)

## UI -> WorldScene 
signal refresh_formation(current_formation : FormationResource) # legacy
signal level_updated(level: LevelResource)

## UI -> CenterEnemyEditor -> CreateNewEnemyDialog
signal request_create_new_enemy_dialog(current_formation : FormationResource, context: Dictionary)
signal enemy_editor_refresh(urrent_formation : FormationResource)

## Helpers and notifier
signal active_window_notifier(window: String)


func emit_active_window_notifier(window: String):
	if debug:
		print("[ui_signal_bus] -> emit_active_window_notifier")
	active_window_notifier.emit(window)


func emit_is_editor_ready(state : bool):
	if debug:
		print("[ui_signal_bus] -> emit_is_editor_ready")
	is_editor_ready.emit(state)


func emit_level_updated(level: LevelResource):
	if debug:
		print("[ui_signal_bus] -> emit_level_updated")
	level_updated.emit(level)


func emit_enemy_editor_refrehs(urrent_formation : FormationResource) -> void:
	if debug:
		print("[ui_signal_bus] -> enemy_editor_refrehs")
	enemy_editor_refresh.emit(urrent_formation)


func emit_request_create_new_enemy_dialog(current_formation : FormationResource, context: Dictionary):
	if debug:
		print("[ui_signal_bus] -> request_create_new_enemy_dialog")
	request_create_new_enemy_dialog.emit(current_formation, context)


func emit_refresh_formation(current_formation : FormationResource):
	if debug:
		print("[ui_signal_bus] -> refresh_formation")
	refresh_formation.emit(current_formation)

func emit_formation_updated(current_formation : FormationResource):
	if debug:
		print("[ui_signal_bus] -> formation_updated")
	formation_updated.emit(current_formation)

func emit_symbol_selected(symbol: String):
	if debug:
		print("[ui_signal_bus] -> symbol_selected")
	symbol_selected.emit(symbol)


func emit_extended_symbol_add(overrides: Array[EnemyOverrideResource]):
	if debug:
		print("[ui_signal_bus] -> extended_symbol_add")
	extended_symbol_add.emit(overrides)


func emit_extended_symbol_erase(key: String):
	if debug:
		print("[ui_signal_bus] -> extended_symbol_erase")
	extended_symbol_erase.emit(key)

	
	
	
	
	
