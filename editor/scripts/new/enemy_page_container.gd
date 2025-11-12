extends VBoxContainer


@onready var texture_rect: TextureRect = $PanelContainer/HBoxContainer/Pic/TextureRect
@onready var base_health_label: Label = $PanelContainer/HBoxContainer/Description/VBoxContainer/BaseHealthLabel
@onready var base_points_label: Label = $PanelContainer/HBoxContainer/Description/VBoxContainer/BasePointsLabel
@onready var base_symble: Label = $PanelContainer/HBoxContainer/Description/VBoxContainer/BaseSymble
@onready var add_new_button: Button = $PanelContainer/HBoxContainer/EditControll/VBoxContainer/AddNewButton
@onready var fork_container: MarginContainer = $ForkContainer


var formation_res: FormationResource


func setup(formation: FormationResource, context : Dictionary, enemy_id ):
	formation_res = formation
	name = context["sname"] 
	base_symble.text = "BaseSymble : %s " % enemy_id
	base_health_label.text = "Health : %s" % context["base_hp"] 
	base_points_label.text = "Points : %s" % context["base_point"]
	texture_rect.texture = load(context.get("pic"))
	add_new_button.name = enemy_id
	add_new_button.pressed.connect(_on_add_new_button_pressed.bind(enemy_id))
	fork_container.setup(formation,enemy_id)


func _on_add_new_button_pressed(id) -> void:
	print('[NewEnemyDialog] -> _on_add_new_button_pressed with id: ' + id)
	var context = {"enemy_id" : id }
	# тут нужна другая кнопка
	UiSignalBus.emit_request_create_new_enemy_dialog(formation_res,context) 
