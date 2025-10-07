extends Node2D

@onready var lm2: LevelManager2 = $LevelManager2
@onready var file_dialog: FileDialog = $UIRoot/FileDialog
@onready var save_file_dialog: FileDialog = $UIRoot/SaveFileDialog

var is_move = false
var is_loaded = false
var current_formation: FormationResource2
@onready var level_res: LevelResource2 = LevelResource2.new()

func _ready() -> void:
	UiSignalBus.refresh_formation.connect(_on_refrash_formation)
	file_dialog.file_selected.connect(_on_file_dialog_file_selected) # <- тоже видимо убрать надо

func _process(delta: float) -> void:
	if is_move and is_loaded:
		lm2.move_formation(delta)

func _on_file_index_pressed(index: int) -> void:
	match index:
		0:
			_create_new_lvl()
		1:
			file_dialog.popup()
		3:
			get_tree().quit() ##todo кастомный выход с подтверждением
		2:	
			save_file_dialog.popup()

func _on_check_button_toggled(toggled_on: bool) -> void:
	is_move = toggled_on

func _on_movement_speed_slider_value_changed(value: float) -> void:
	current_formation.movement_speed = value
	lm2.change_current_formation_movement_speed(value)

func _on_down_movement_speed_slider_value_changed(value: float) -> void:
	current_formation.shift_down_speed = value
	lm2.change_current_down_movement_speed(value)
	
# не работает =((( 
func _save_resource_to_file(resource_instance: LevelResource2, file_path: String) -> void:
	# Важно: resource_instance - это экземпляр вашего MyRes, который мы создали и редактировали
	# file_path - это полный путь, куда сохранить, например: "user://my_save.tres"
	# Используем встроенный метод ResourceSaver
	print("Saving to: ", file_path)
	print("Exists dir: ", DirAccess.dir_exists_absolute(file_path.get_base_dir()))
	if not file_path.ends_with(".tres") and not file_path.ends_with(".res"):
		file_path += ".tres"
	var error_code = ResourceSaver.save(resource_instance, file_path)
	# Проверяем, успешно ли прошло сохранение
	if error_code == OK:
		print("Ресурс успешно сохранен в файл: ", file_path)
	else:
		push_error("Произошла ошибка при сохранении. Код ошибки: " + str(error_code))

func _on_refrash_formation(cf : FormationResource2 ) -> void:
	get_tree().call_group("enemies", "queue_free")
	lm2.update_current_fromation(cf)

func _create_new_lvl() -> void:
	var new_lvl : LevelResource2 = LevelResource2.new()
	var new_formation = FormationResource2.new()   
	  
	new_formation.enemy_overrides.append(EnemyOverrideResource.new())

	new_lvl.formation = new_formation  
	
	get_tree().call_group("enemies", "queue_free")
	lm2.clear_lvl_res()
	lm2.create_level(new_lvl)
	current_formation = lm2.get_current_formation_info()
	UiSignalBus.emit_formation_updated(current_formation)


#region FileDialog (Load\Save)
func _on_save_file_dialog_file_selected(path: String) -> void:
	if current_formation != null: 
		level_res.formation = current_formation
		_save_resource_to_file(level_res, path)
	else:
		%WarningPopup.popup()

func _on_file_dialog_file_selected(path: String):
	get_tree().call_group("enemies", "queue_free")
	lm2.clear_lvl_res()
	lm2.add_lvl_res(path)
	is_loaded = lm2.load_level(0)
	if is_loaded:
		current_formation = lm2.get_current_formation_info()
		UiSignalBus.emit_formation_updated(current_formation)
		# _show_lvl_info(current_formation) # <- в сигнал нах

#endregion
