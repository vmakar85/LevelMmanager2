extends FileDialog

var active_level: LevelResource

func _on_file_selected(path: String) -> void:
	var loaded = LevelResource.load_from_file(path)
	UiSignalBus.emit_level_updated(loaded)
