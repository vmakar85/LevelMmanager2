extends CanvasLayer

@onready var grid_editor: MarginContainer = %CenterGridEditor
@onready var enemy_editor: MarginContainer = %CenterEnemyEditor


func _ready() -> void:
	UiSignalBus.formation_updated.connect(_on_formation_updated)
	%infoPanel.visible = false
	%ControllPanel.visible = false

func _on_formation_updated(formation_resource: FormationResource2):
	# ... обновляем все элементы UI ...
	_show_lvl_info(formation_resource)
	grid_editor.setup(formation_resource)
	enemy_editor.setup(formation_resource)

func _show_lvl_info(cf : FormationResource2) -> void:
	%lvlNameLabel.text = "lvl name: " + cf.level_name
	%movement_speed.text = "movement speed: " + str(cf.movement_speed)
	%movement_speed_slider.value = cf.movement_speed
	%movement_speed_control_lable.text = "Speed : " + str(cf.movement_speed)
	%shift_down_speed.text = "shiftdown speed: " + str(cf.shift_down_speed)
	%down_movement_speed_control_lable.text = "shiftdown speed: " + str(cf.shift_down_speed)
	%down_movement_speed_slider.value = cf.shift_down_speed
	%start_y.text = "start y: " + str(cf.start_y)
	%infoPanel.visible = true
	%ControllPanel.visible = true

func _on_movement_speed_slider_value_changed(value: float) -> void:
	%movement_speed_control_lable.text = "Side speed : " + str(value)

func _on_down_movement_speed_slider_value_changed(value: float) -> void:
	%down_movement_speed_control_lable.text = "Shiftdown speed: " + str(value)

func _on_edit_formation_pressed() -> void:
	%CenterGridEditor.visible = !%CenterGridEditor.visible
	if %CenterGridEditor.visible :
		%CenterEnemyEditor.visible = false

func _on_edit_enemies_pressed() -> void:
	%CenterEnemyEditor.visible = !%CenterEnemyEditor.visible
	if %CenterEnemyEditor.visible :
		%CenterGridEditor.visible = false
