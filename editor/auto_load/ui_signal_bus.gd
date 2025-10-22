extends Node

# --- Включи на время разработки, чтобы видеть кто что эмитит
@export var debug: bool = true

## UI - GridEditor
signal symbol_selected(symbol: String)
signal extended_symbol_add(overrides: Array[EnemyOverrideResource])
signal extended_symbol_erase(key: String)
## UI - Main (UIRoot)
signal formation_updated(current_formation : FormationResource2)

## UI -> WorldScene 
signal refresh_formation(current_formation : FormationResource2)

## UI -> CenterEnemyEditor -> CreateNewEnemyDialog
signal request_create_new_enemy_dialog(current_formation : FormationResource2, context: Dictionary)
signal enemy_editor_refresh(urrent_formation : FormationResource2)

func emit_enemy_editor_refrehs(urrent_formation : FormationResource2) -> void:
	if debug:
		print("enemy_editor_refrehs")
	enemy_editor_refresh.emit(urrent_formation)

func emit_request_create_new_enemy_dialog(current_formation : FormationResource2, context: Dictionary):
	if debug:
		print("request_create_new_enemy_dialog")
	request_create_new_enemy_dialog.emit(current_formation, context)

func emit_refresh_formation(current_formation : FormationResource2):
	if debug:
		print("refresh_formation")
	refresh_formation.emit(current_formation)

func emit_formation_updated(current_formation : FormationResource2):
	if debug:
		print("formation_updated")
	formation_updated.emit(current_formation)

func emit_symbol_selected(symbol: String):
	if debug:
		print("symbol_selected")
	symbol_selected.emit(symbol)

func emit_extended_symbol_add(overrides: Array[EnemyOverrideResource]):
	if debug:
		print("extended_symbol_add")
	extended_symbol_add.emit(overrides)

func emit_extended_symbol_erase(key: String):
	if debug:
		print("extended_symbol_erase")
	extended_symbol_erase.emit(key)

	
	
	
	
	
