extends CanvasLayer



func _ready() -> void:
#	UiSignalBus.formation_updated.connect(_on_formation_updated)
	UiSignalBus.level_updated.connect(_on_level_updated)


func _on_formation_updated(formation_resource: FormationResource):
	# ... обновляем все элементы UI ...
	_update_lvl_info(formation_resource)


func _update_lvl_info(cf: FormationResource) -> void:
	%lvlNameLabel.text = "lvl name: " + cf.level_name
	%movement_speed.text = "movement speed: " + str(cf.movement_speed)
	%movement_speed_slider.value = cf.movement_speed
	%movement_speed_control_lable.text = "Speed : " + str(cf.movement_speed)
	%shift_down_speed.text = "shiftdown speed: " + str(cf.shift_down_speed)
	%down_movement_speed_control_lable.text = "shiftdown speed: " + str(cf.shift_down_speed)
	%down_movement_speed_slider.value = cf.shift_down_speed
	%start_y.text = "start y: " + str(cf.start_y)


func _on_level_updated(level: LevelResource):
	_update_lvl_info(level.formation)





	
