# enemy_editor.gd
extends MarginContainer

@onready var main_tab_container: TabContainer = $Panel/MainTabContainer


var formation_res: FormationResource2
var available_powerups: Array = ["shield", "double_shot", "extra_life", "bomb", "speed_boost"] # Можно вынести в Resources

func setup(formation: FormationResource2):
	formation_res = formation
	_update(formation)

func _update(formation: FormationResource2) -> void:
	clear_tabs(main_tab_container)

	for s in Resources.enemy_description:
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

		var vbox_cnt_in_des_cnt = VBoxContainer.new()
		vbox_cnt_in_des_cnt.name = "vbox_cnt_in_des_cnt" + s
		des_cnt.add_child(vbox_cnt_in_des_cnt)

		var base_health_label = Label.new()
		base_health_label.name = "base_health_label" + s
		base_health_label.text = "BaseHealthLabel : %s" 
		vbox_cnt_in_des_cnt.add_child(base_health_label)

		var base_points_label = Label.new()
		base_points_label.name = "base_points_label" + s
		base_points_label.text = "BasePointsLabel : %s"
		vbox_cnt_in_des_cnt.add_child(base_points_label)

		hbox_cnt.add_child(des_cnt)

		# --- Edit Controls (MarginContainer + VBoxContainer + кнопки)
		var edit_cnt = MarginContainer.new()
		edit_cnt.name = "edit_cnt" + s
		_margin_theme_constant_override(edit_cnt)
		edit_cnt.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var vbox_controls = VBoxContainer.new()
		vbox_controls.name = "vbox_controls" + s
		edit_cnt.add_child(vbox_controls)

		var edit_base_btn = Button.new()
		edit_base_btn.name = "edit_base_btn" + s
		edit_base_btn.text = "Edit base"
		vbox_controls.add_child(edit_base_btn)

		var add_new_btn = Button.new()
		add_new_btn.name = "add_new_btn" + s
		add_new_btn.text = "Add fork"
		vbox_controls.add_child(add_new_btn)

		hbox_cnt.add_child(edit_cnt)

		# Создаём контейнер для форков
		var fork_cnt = MarginContainer.new()
		fork_cnt.name = "fork_cnt" + s
		_margin_theme_constant_override(fork_cnt)
		vbox_cnt.add_child(fork_cnt)

		# Внутри него будет VBox, куда сложим все fork-ui
		var forks_box = VBoxContainer.new()
		fork_cnt.add_child(forks_box)

		# Теперь добавляем форки в forks_box
		#var forks = formation.get_enemy_forks(s)
		#for fork in forks:
			#create_fork_ui(forks_box, fork)  # <- не в vbox_cnt, а в forks_box




func _update2(formation: FormationResource2) -> void:
	# Чистим
	clear_tabs(main_tab_container)

	## Проходим по всем типам наших корабликов и заполняем табы 
	## если у нас есть доп инфа в formation - обновляем доп секцию
	for s in Resources.enemy_description:
		var enemy = Resources.enemy_description[s]
		var tab = TabBar.new()
		tab.set_meta("symbol", s)
			## тут параметры таба
		tab.name = enemy["sname"]
		
		## -------------------------------------------
		var vbox_cnt = VBoxContainer.new()
			## тут параметры первого контейнера VBoxContainer
		tab.add_child(vbox_cnt)
		## -------------------------------------------
		var hbox_cnt = HBoxContainer.new()
			## тут параметры первого контейнера HBoxContainer
		vbox_cnt.add_child(hbox_cnt)
		## -------------------------------------------
		var pic_cnt = MarginContainer.new()
			## тут параметры первого контейнера PictureMarginContainer
		_margin_theme_constant_override(pic_cnt)
		var text_rec = TextureRect.new()
		text_rec.texture = load(enemy.get("pic"))
		pic_cnt.add_child(text_rec)
		hbox_cnt.add_child(pic_cnt)
		## -------------------------------------------
		var des_cnt = MarginContainer.new()
			## тут параметры первого контейнера DescriptionMarginContainer
		_margin_theme_constant_override(des_cnt)
		des_cnt.size_flags_horizontal = true
		var vbox_cnt_in_des_cnt = VBoxContainer.new()
		des_cnt.add_child(vbox_cnt_in_des_cnt)
		var base_health_label = Label.new()
		var base_points_label = Label.new()
		var enemy_data = formation.get_enemy_data(s, {
			"health": enemy["base_hp"],
			"points": enemy["base_point"],
			"self_name": enemy["name"]
		})
		base_health_label.text = "Base health: " + str(enemy_data["health"])
		base_points_label.text = "Base points: " + str(enemy_data["points"])
		vbox_cnt_in_des_cnt.add_child(base_health_label)
		vbox_cnt_in_des_cnt.add_child(base_points_label)
		hbox_cnt.add_child(des_cnt)
		## -------------------------------------------
		var edit_cnt = MarginContainer.new()
			## тут параметры первого контейнера EditorMarginContainer
		_set_container_sizing(edit_cnt)
		_margin_theme_constant_override(edit_cnt)
		hbox_cnt.add_child(edit_cnt)
		## -------------------------------------------
		var fork_cnt = MarginContainer.new()
		fork_cnt.name = "fork_container_" + s
		fork_cnt.size_flags_vertical = Control.SIZE_EXPAND_FILL
		fork_cnt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fork_cnt.set_anchors_preset(LayoutPreset.PRESET_FULL_RECT)
		
		_margin_theme_constant_override(fork_cnt)
		var pnl = Panel.new()
		pnl.name = "pnl_" + s
		fork_cnt.add_child(pnl)
		var scrl_cnt = ScrollContainer.new()
		scrl_cnt.name = "scrl_cnt" + s
		scrl_cnt.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		_full_rect(scrl_cnt)
		pnl.add_child(scrl_cnt)
		var vbox_fork_cnt = VBoxContainer.new()
		scrl_cnt.add_child(vbox_fork_cnt)
## -------------------------------------------
		#var forks = formation.get_enemy_forks(s)
		#for fork in forks: # <- В наличие есть объект
			#var fork_ui = create_fork_ui(enemy, fork)
			#vbox_fork_cnt.add_child(fork_ui)  # <- В наличие есть объект
## -------------------------------------------
		vbox_cnt.add_child(fork_cnt)
		main_tab_container.add_child(tab)

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
		
func create_fork_ui3(parent: VBoxContainer, fork_data: Dictionary) -> void:
	var fork_cnt = MarginContainer.new()
	fork_cnt.name = "fork_cnt" + fork_data.get("enemy", "?")
	_margin_theme_constant_override(fork_cnt)
	fork_cnt.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(fork_cnt)

	var vbox = VBoxContainer.new()
	vbox.name = "vbox" + fork_data.get("enemy", "?")
	fork_cnt.add_child(vbox)

	# Пример: показываем врага и powerup
	var enemy_label = Label.new()
	enemy_label.name = "enemy_label" + fork_data.get("enemy", "?")
	enemy_label.text = "Enemy type: %s" % fork_data.get("enemy", "?")
	vbox.add_child(enemy_label)

	var powerup_label = Label.new()
	powerup_label.name = "powerup_label" + fork_data.get("enemy", "?")
	powerup_label.text = "Powerup: %s" % fork_data.get("powerup", "?")
	vbox.add_child(powerup_label)

	# (для теста – добавь кнопку, чтобы точно видеть)
	var del_btn = Button.new()
	del_btn.name = "del_btn" + fork_data.get("enemy", "?")
	del_btn.text = "Delete fork"
	vbox.add_child(del_btn)

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
