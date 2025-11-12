extends MarginContainer


func _ready() -> void:
	UiSignalBus.is_editor_ready.connect(_on_editor_ready)


func _on_editor_ready(_b: bool):
	pass
