# enemy_editor.gd
extends MarginContainer

@onready var main_tab_container: TabContainer = $Panel/MainTabContainer


var formation_res: FormationResource2
var available_powerups: Array = ["shield", "double_shot", "extra_life", "bomb", "speed_boost"] # Можно вынести в Resources

func setup(formation: FormationResource2):
	formation_res = formation
	_update()

func _update() -> void:
	clear_tabs(main_tab_container)
	# пробегаем по всем базавым врагам и нацеживаем
	# в них EnemyOverrideResource и PowerupMappingResource
	for s in Resources.enemy_description: 
		# базовое описание
		var enemy = Resources.enemy_description[s]
		# Создаём вкладку (VBoxContainer)
		var vbox_cnt = VBoxContainer.new()
		vbox_cnt.name = enemy["sname"]  # название вкладки
		main_tab_container.add_child(vbox_cnt)

		# --- Основной HBox (слева картинка, справа описание, ещё правее контролы)
		var hbox_cnt = HBoxContainer.new()
		hbox_cnt.name = "hbox_cnt" + s
		vbox_cnt.add_child(hbox_cnt)

		# --- Pic (MarginContainer + TextureRect)
		var pic_cnt = MarginContainer.new()
		pic_cnt.name = "pic_cnt" + s
		_margin_theme_constant_override(pic_cnt)

		var text_rec = TextureRect.new()
		text_rec.name = "text_rec" + s
		text_rec.texture = load(enemy.get("pic"))
		pic_cnt.add_child(text_rec)
		
		hbox_cnt.add_child(pic_cnt)

		# --- Description (MarginContainer + VBoxContainer + labels)
		var des_cnt = MarginContainer.new()
		des_cnt.name = "des_cnt" + s
		_margin_theme_constant_override(des_cnt)
		des_cnt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
#region label for params
		create_descripttion_ui(des_cnt, s, enemy)
#endregion
		hbox_cnt.add_child(des_cnt)
		# --- Edit Controls (MarginContainer + VBoxContainer + кнопки)
		var edit_cnt = MarginContainer.new()
		edit_cnt.name = "edit_cnt" + s
		_margin_theme_constant_override(edit_cnt)
		edit_cnt.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var vbox_controls = VBoxContainer.new()
		vbox_controls.name = "vbox_controls" + s
		edit_cnt.add_child(vbox_controls)

		var edit_base_btn = create_button(vbox_controls,"edit_base_btn" + s, "Edit base")
		edit_base_btn.pressed.connect(_on_edit_base_button_pressed.bind(s))

		var add_new_btn = create_button(vbox_controls,"add_new_btn" + s, "Add fork")
		add_new_btn.pressed.connect(_on_add_new_button_pressed.bind(s))
		hbox_cnt.add_child(edit_cnt)
#region контейнер для форков 
		# Создаём контейнер для форков
		var fork_cnt = MarginContainer.new()
		fork_cnt.name = "fork_cnt" + s
		_set_container_sizing(fork_cnt,Control.SIZE_EXPAND_FILL,Control.SIZE_EXPAND_FILL)
		_margin_theme_constant_override(fork_cnt)
		vbox_cnt.add_child(fork_cnt)

		var src_fork_cnt = ScrollContainer.new()
		fork_cnt.add_child(src_fork_cnt)
		_set_container_sizing(src_fork_cnt,Control.SIZE_EXPAND_FILL,Control.SIZE_EXPAND_FILL)
		# Внутри него будет VBox, куда сложим все fork-ui
		var forks_box = VBoxContainer.new()
		src_fork_cnt.add_child(forks_box)
		
		# Теперь добавляем форки в forks_box
		# так а тут теперь будем делать форки если есть....
		var powerups_for_enemy = formation_res.get_powerups_for_enemy(s)
		
		for pfe in powerups_for_enemy:
			var pfe_s = pfe.get_key()
			var powerup_name = pfe.get_powerup_name()
			
			var efp = Panel.new()
			forks_box.add_child(efp)
			
			var vbox = create_descripttion_ui(efp, pfe_s, enemy)
			
			var powerup_label = Label.new()
			powerup_label.text = "Powerup: %s" % powerup_name
			vbox.add_child(powerup_label)
			
			create_button(vbox,"del_btn" + s, "Delete fork %s " % pfe_s)
		#var forks = formation.get_enemy_forks(s)
		#for fork in forks:
			#create_fork_ui(forks_box, fork)  # <- не в vbox_cnt, а в forks_box
#endregion



func _margin_theme_constant_override(node: Control,margin_value = 20 ) -> void:
	node.add_theme_constant_override("margin_top", margin_value)
	node.add_theme_constant_override("margin_left", margin_value)
	node.add_theme_constant_override("margin_bottom", margin_value)
	node.add_theme_constant_override("margin_right", margin_value)

func _full_rect(node: Control) -> void:
	node.set_anchors_preset(LayoutPreset.PRESET_FULL_RECT)

func _set_container_sizing(node: Control, h_flag: int = Control.SIZE_SHRINK_CENTER, v_flag: int = Control.SIZE_SHRINK_CENTER) -> void:
	node.size_flags_horizontal = h_flag
	node.size_flags_vertical = v_flag

func clear_tabs(tab_container: TabContainer) -> void:
	for i in range(tab_container.get_tab_count() - 1, -1, -1):
		var child = tab_container.get_tab_control(i)
		child.queue_free()

func create_fork_ui(parent: VBoxContainer, fork: Dictionary) -> void:
	var vbox = VBoxContainer.new()
	parent.add_child(vbox)

	var enemy_label = Label.new()
	enemy_label.text = "Enemy: %s" % fork["enemy"]
	vbox.add_child(enemy_label)

	var powerup_label = Label.new()
	powerup_label.text = "Powerup: %s" % fork["powerup"]
	vbox.add_child(powerup_label)

	var del_btn = Button.new()
	del_btn.text = "Delete fork"
	vbox.add_child(del_btn)

func create_button(parent : Control, salf_name: String, text: String) -> Button:
	var btn = Button.new()
	btn.name = salf_name
	btn.text = text
	parent.add_child(btn)
	return btn

func create_descripttion_ui(parent, s, enemy) -> VBoxContainer:
	var vbox_cnt_in_des_cnt = VBoxContainer.new()
	vbox_cnt_in_des_cnt.name = "vbox_cnt_in_des_cnt" + s
	parent.add_child(vbox_cnt_in_des_cnt)
	
	var enemy_lbl = Label.new()
	var bhp 
	var bpp
	enemy_lbl.text = "Enemy: %s " % s
	enemy_lbl.name = "enemy_name" + s
	vbox_cnt_in_des_cnt.add_child(enemy_lbl)
	
	var override = formation_res.get_enemy_override(s)
	
	if override != null and override.get_health() != -1:
		bhp = override.get_health()
	else:
		bhp = enemy["base_hp"] 
	if override != null and override.get_points() != -1:
		bpp = override.get_points()
	else: 
		bpp = enemy["base_point"]
		
	var base_health_label = Label.new()
	base_health_label.name = "base_health_label" + s
	base_health_label.text = "Health : %s" % bhp 
	vbox_cnt_in_des_cnt.add_child(base_health_label)

	var base_points_label = Label.new()
	base_points_label.name = "base_points_label" + s
	base_points_label.text = "Points : %s" % bpp
	vbox_cnt_in_des_cnt.add_child(base_points_label)
	return vbox_cnt_in_des_cnt

# вызывается при нажатии на кнопку редактирования базовых параметров
func _on_edit_base_button_pressed(id) -> void:
	print(id) # ага приходит id 

func _on_add_new_button_pressed(id) -> void:
	print(id)
	UiSignalBus.emit_request_create_new_enemy_dialog(formation_res) 
