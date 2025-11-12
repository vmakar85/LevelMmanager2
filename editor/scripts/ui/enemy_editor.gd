extends MarginContainer

@onready var main_tab_container: TabContainer = $Panel/MainTabContainer

var formation_res: FormationResource
var active_level: LevelResource


func _ready() -> void:
	UiSignalBus.enemy_editor_refresh.connect(_on_enemy_editor_refresh)
#	UiSignalBus.formation_updated.connect(_on_formation_updated)
	UiSignalBus.level_updated.connect(_on_level_updated)


func setup(formation: FormationResource):
	formation_res = formation
	clear_tabs(main_tab_container)
	_update()

func _update() -> void:
	for s in Resources.enemy_description: 
		var enemy:Dictionary = Resources.enemy_description[s] 
		var enemy_page: PackedScene = load("res://editor/scenes/enemy_page_container.tscn")
		var enemy_page_i = enemy_page.instantiate()
		main_tab_container.add_child(enemy_page_i)
		enemy_page_i.setup(formation_res, enemy, s)

func _on_delete_button(o_overrided_id):
	print(o_overrided_id)
	var newoer = formation_res.delete_overrides_by_key(o_overrided_id)
	formation_res.enemy_overrides = newoer
	setup(formation_res)

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
func _on_add_new_button_pressed(id) -> void:
	var context = {"enemy_id" : id }
	# тут нужна другая кнопка
	UiSignalBus.emit_request_create_new_enemy_dialog(formation_res,context) 

func _on_enemy_editor_refresh(formation: FormationResource) -> void:
	setup(formation)

func _on_formation_updated(formation_resource: FormationResource):
	setup(formation_resource)

func popup(_data: Dictionary = {}): 
	UiSignalBus.emit_active_window_notifier('enemies_editor')


func popdown():
	pass


func _on_level_updated(level: LevelResource):
	active_level = level
	_on_formation_updated(active_level.formation)




	
