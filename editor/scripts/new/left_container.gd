extends MarginContainer

@onready var dialogs_and_windows: Node = $"../DialogsAndWindows"


func _ready() -> void:
	UiSignalBus.is_editor_ready.connect(_on_editor_ready)
	%movement_speed_slider.editable = false
	%down_movement_speed_slider.editable = false
	%MoveFormationTaggle.disabled = true


func _on_move_formation_taggle_toggled(_toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_movement_speed_slider_value_changed(value: float) -> void:
	%movement_speed_control_lable.text = "Side speed : " + str(value)


func _on_down_movement_speed_slider_value_changed(value: float) -> void:
	%down_movement_speed_control_lable.text = "Shiftdown speed: " + str(value)


func _on_edit_formation_pressed() -> void:
	dialogs_and_windows.switch_to_window(dialogs_and_windows.WindowState.FORMATION_EDITOR)


func _on_edit_enemies_pressed() -> void:
	dialogs_and_windows.switch_to_window(dialogs_and_windows.WindowState.ENEMIES_EDITOR)

func _on_editor_ready(_b: bool):
	%movement_speed_slider.editable = true
	%down_movement_speed_slider.editable = true
	%MoveFormationTaggle.disabled = false



	
