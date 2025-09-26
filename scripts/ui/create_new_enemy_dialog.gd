extends ConfirmationDialog

var letters: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W"]
var formation_res: FormationResource2

@onready var new_symbol_label: Label = $MarginContainer/VBoxContainer/NewSymbolLabel
@onready var option_button: OptionButton = $MarginContainer/VBoxContainer/HBoxContainer3/OptionButton

var selected_powerup
var p_amount: int = 1
var h_amount: int = 1

func _ready() -> void:
	UiSignalBus.request_create_new_enemy_dialog.connect(_on_request_create_new_enemy_dialog)
	# Пробегаем по enum и добавляем варианты
	for key in PowerupResource.PowerupType.keys():
		var id = PowerupResource.PowerupType[key]
		option_button.add_item(key.capitalize(), id)

func setup(formation: FormationResource2) -> void:
	formation_res = formation
	var new_symbol =  get_available_symbol()
	new_symbol_label.text = "Enemy: %s " % new_symbol


func get_available_symbol() -> String:
	for s in letters:
		if formation_res.get_powerup_by_key(s) == null:
			return s
	return "No available symble"

func _on_request_create_new_enemy_dialog(formation: FormationResource2):
	setup(formation)
	show()


func _on_h_option_button_item_selected(index: int) -> void:
	p_amount = %HOptionButton.get_item_text(index).to_int()

func _on_p_option_button_item_selected(index: int) -> void:
	h_amount = %POptionButton.get_item_text(index).to_int()
