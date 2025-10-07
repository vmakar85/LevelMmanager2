# enemy_editor.gd
extends MarginContainer

@onready var main_tab_container: TabContainer = $Panel/MainTabContainer

var formation_res: FormationResource2

func _ready() -> void:
	UiSignalBus.enemy_editor_refresh.connect(_on_enemy_editor_refresh)

func setup(formation: FormationResource2):
	formation_res = formation
	_update()

func _update() -> void:
	clear_tabs(main_tab_container) # <- возможно не стоит чисттить это именно в контейнере табов
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
		UIHelper.margin_theme_constant_override(pic_cnt)

		var text_rec = TextureRect.new()
		text_rec.name = "text_rec" + s
		text_rec.texture = load(enemy.get("pic"))
		pic_cnt.add_child(text_rec)
		
		hbox_cnt.add_child(pic_cnt)

		# --- Description (MarginContainer + VBoxContainer + labels)
		var des_cnt = MarginContainer.new()
		des_cnt.name = "des_cnt" + s
		UIHelper.margin_theme_constant_override(des_cnt)
		des_cnt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
#region label for params
		create_descripttion_ui(des_cnt, s, enemy)
#endregion
		hbox_cnt.add_child(des_cnt)
		# --- Edit Controls (MarginContainer + VBoxContainer + кнопки)
		var edit_cnt = MarginContainer.new()
		edit_cnt.name = "edit_cnt" + s
		UIHelper.margin_theme_constant_override(edit_cnt)
		edit_cnt.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var vbox_controls = VBoxContainer.new()
		vbox_controls.name = "vbox_controls" + s
		edit_cnt.add_child(vbox_controls)

		#var edit_base_btn = create_button(vbox_controls,"edit_base_btn" + s, "Edit base")
		#edit_base_btn.pressed.connect(_on_edit_base_button_pressed.bind(s))

		var add_new_btn = create_button(vbox_controls,"add_new_btn" + s, "Add fork")
		add_new_btn.pressed.connect(_on_add_new_button_pressed.bind(s))
		hbox_cnt.add_child(edit_cnt)
#region контейнер для форков 
		## fork-ui
		var fork_scene: PackedScene = load("res://editor/scenes/fork_container.tscn")
		var fork_cnt = fork_scene.instantiate()
		vbox_cnt.add_child(fork_cnt)
		var fork_container = fork_cnt.get_node('ForkPanel/ForkScrollContainer/ForkContainer')
		# получаем список всех перегрузок для уникального ключа enemy_id
		var overrides = formation_res.get_overrides_by_key(s)
		for ovr in overrides:
			#var o_enemy_id = ovr.get_enemy_id()
			var o_overrided_id = ovr.get_enemy_overrided_id()
			#var o_health = ovr.get_health()
			#var o_points = ovr.get_points()
			var o_powerup_name = ovr.get_powerup_name()
			
			var fork_cnt_panel = PanelContainer.new()
			fork_container.add_child(fork_cnt_panel)
			
			var mcn = MarginContainer.new()
			mcn.name = "edit_cnt" + s
			UIHelper.margin_theme_constant_override(mcn)
			mcn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			fork_cnt_panel.add_child(mcn)

			var vbox = create_descripttion_ui(mcn, o_overrided_id, enemy)
			var powerup_label = Label.new()
			powerup_label.text = "Powerup: %s" % o_powerup_name
			vbox.add_child(powerup_label)
			var button = create_button(vbox,"del_btn" + s, "Delete fork %s " % o_overrided_id)
			button.pressed.connect(_on_delete_button.bind(o_overrided_id))
#endregion

func _on_delete_button(o_overrided_id):
	print(o_overrided_id)
	var newoer = formation_res.delete_overrides_by_key(o_overrided_id)
	formation_res.enemy_overrides = newoer
	setup(formation_res)
	setup(formation_res)

func _full_rect(node: Control) -> void:
	node.set_anchors_preset(LayoutPreset.PRESET_FULL_RECT)

func _set_container_sizing(node: Control, h_flag: int = Control.SIZE_SHRINK_CENTER, v_flag: int = Control.SIZE_SHRINK_CENTER) -> void:
	node.size_flags_horizontal = h_flag
	node.size_flags_vertical = v_flag

func clear_tabs(tab_container: TabContainer) -> void:
	for i in range(tab_container.get_tab_count() - 1, -1, -1):
		var child = tab_container.get_tab_control(i)
		child.queue_free()

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
	
	var override = formation_res.get_override(s)
	
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
	var context = {"enemy_id" : id }
	UiSignalBus.emit_request_create_new_enemy_dialog(formation_res,context) 

func _on_enemy_editor_refresh(formation: FormationResource2) -> void:
	setup(formation)
