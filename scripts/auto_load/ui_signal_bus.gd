extends Node

## UI - GridEditor
signal symbol_selected(symbol: String)
signal extended_symbol_add(powerup_mapping: Array[PowerupMappingResource])
signal extended_symbol_erase(key: String)
## UI - Main (UIRoot)
signal formation_updated(current_formation : FormationResource2)

## UI -> WorldScene 
signal refresh_formation(current_formation : FormationResource2)

func emit_refresh_formation(current_formation : FormationResource2):
	refresh_formation.emit(current_formation)

func emit_formation_updated(current_formation : FormationResource2):
	formation_updated.emit(current_formation)

func emit_symbol_selected(symbol: String):
	symbol_selected.emit(symbol)

func emit_extended_symbol_add(powerup_mapping: Array[PowerupMappingResource]):
	extended_symbol_add.emit(powerup_mapping)

func emit_extended_symbol_erase(key: String):
	extended_symbol_erase.emit(key)

	
	
	
	
	
