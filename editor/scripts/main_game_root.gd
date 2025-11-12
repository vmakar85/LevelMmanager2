extends Node2D


@onready var level_manager: LevelManager = $LevelManager
var is_loaded : bool = false


func _ready() -> void:
	UiSignalBus.level_updated.connect(_on_level_updated)


func _on_level_updated(level: LevelResource):
	is_loaded = level_manager.create_level_from_resource(level)
	if is_loaded:
		if Globals.is_debug:
			print("[MainGameRoot] is_loaded = true , level_name : " + level.formation.level_name)
		UiSignalBus.emit_is_editor_ready(true)
