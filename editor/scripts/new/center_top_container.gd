extends MarginContainer

var current_formation: FormationResource
@onready var dialogs_and_windows: Node = $"../DialogsAndWindows"


func _ready() -> void:
	UiSignalBus.is_editor_ready.connect(_on_editor_ready)
	UiSignalBus.formation_updated.connect(_on_formation_updated)
	UiSignalBus.level_updated.connect(_on_level_updated)


func _process(_delta: float) -> void:
	if current_formation == null:
		$HBoxContainer/Save.disabled = true
	else:
		$HBoxContainer/Save.disabled = false


func _on_new_pressed() -> void:
	dialogs_and_windows.switch_to_window(dialogs_and_windows.WindowState.NONE)
	%NewLavel.popup()


func _on_open_pressed() -> void:
	%OpenFileDialog.popup()


func _on_save_pressed() -> void:
	%SaveFileDialog.update()
	%SaveFileDialog.popup()


func _on_quit_pressed() -> void:
	%QuitPopup.popup()


func _on_editor_ready(b: bool):
	$HBoxContainer/Save.disabled = !b


func _on_formation_updated(formation_resource: FormationResource):
	current_formation = formation_resource


func _on_level_updated(level: LevelResource):
	current_formation = level.formation


	
	
