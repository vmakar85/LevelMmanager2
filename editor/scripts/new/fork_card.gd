extends PanelContainer

@onready var symble_label: Label = $HBoxContainer/Description/VBoxContainer/SymbleLabel
@onready var health_label: Label = $HBoxContainer/Description/VBoxContainer/HealthLabel
@onready var points_label: Label = $HBoxContainer/Description/VBoxContainer/PointsLabel
@onready var powerup_label: Label = $HBoxContainer/Description/VBoxContainer/PowerupLabel
@onready var self_delete: Button = $HBoxContainer/Description/VBoxContainer/SelfDelete


var formation_res: FormationResource


func setup(formation: FormationResource, symble: String,bhp: int,bpp: int,o_powerup_name: String):
	formation_res = formation
	symble_label.text = "Symble : %s" % symble
	health_label.text = "Health : %s" % bhp
	points_label.text = "Points : %s" % bpp
	powerup_label.text = "Powerup: %s" % o_powerup_name
	self_delete.pressed.connect(_on_delete_button.bind(symble))


func _on_delete_button(o_overrided_id):
	print(o_overrided_id)
	var newoer = formation_res.delete_overrides_by_key(o_overrided_id)
	formation_res.enemy_overrides = newoer
	queue_free()
