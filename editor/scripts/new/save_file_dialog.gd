extends FileDialog

var active_level: LevelResource


func _ready() -> void:
	UiSignalBus.level_updated.connect(_on_level_updated)


func _on_file_selected(path: String) -> void:
	var result_is = active_level.save_to_file(path)
	print('[SaveFileDialog] -> result : ' + result_is)


func _on_level_updated(level: LevelResource):
	active_level = level
