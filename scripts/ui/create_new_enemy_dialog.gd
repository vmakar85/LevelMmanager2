extends ConfirmationDialog

var letters: Array[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W"]
var formation_res: FormationResource2

@onready var new_symbol_label: Label = $MarginContainer/VBoxContainer/NewSymbolLabel
@onready var option_button: OptionButton = $MarginContainer/VBoxContainer/HBoxContainer3/OptionButton
@onready var labelHP: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var labelPoint: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Label
@export var available_powerups: Array[PowerupResource]

var new_symbol
var selected_powerup
var p_amount: int = 1
var h_amount: int = 1
var current_p_amount: int = 0 
var current_hp_amount: int = 0 
var base_enemy_id : String

func _ready() -> void:
	UiSignalBus.request_create_new_enemy_dialog.connect(_on_request_create_new_enemy_dialog)
	# Пробегаем по enum и добавляем варианты
	for key in PowerupResource.PowerupType.keys():
		var id = PowerupResource.PowerupType[key]
		option_button.add_item(key.capitalize(), id)

func setup(formation: FormationResource2, context: Dictionary) -> void:
	base_enemy_id = context['enemy_id']
	formation_res = formation
	new_symbol =  get_available_symbol() # <- получаем новый симворл
	new_symbol_label.text = "Enemy: %s " % new_symbol 
	var enemy = Resources.enemy_description[base_enemy_id]
	current_hp_amount = enemy["base_hp"] # <- получаем базовые хп
	current_p_amount = enemy["base_point"] # <- получаем базовые очки

func _process(_delta: float) -> void:
	labelHP.text = "Health: %s " %  str(current_hp_amount)
	labelPoint.text = "Points: %s " %  str(current_p_amount)

func get_available_symbol() -> String:
	for s in letters:
		if formation_res.get_override_by_key(s) == null:
			return s
	return "No available symble"

func _on_request_create_new_enemy_dialog(formation: FormationResource2, context: Dictionary):
	setup(formation,context)
	show()


func _on_h_option_button_item_selected(index: int) -> void:
	print(%HOptionButton.get_item_text(index))
	h_amount = %HOptionButton.get_item_text(index).to_int()

func _on_p_option_button_item_selected(index: int) -> void:
	p_amount = %POptionButton.get_item_text(index).to_int()

# тут немного сложно, но поехали
## -hp
func _on_button_hp_m_pressed() -> void:
	current_hp_amount = current_hp_amount - h_amount
	if current_hp_amount < 0: 
		current_hp_amount = 0 

## +hp
func _on_button_hp_p_pressed() -> void:
	current_hp_amount = current_hp_amount + h_amount

## -point
func _on_button_pm_pressed() -> void:
	current_p_amount = current_p_amount - p_amount
	if current_p_amount < 0 :
		current_p_amount = 0 

## +point
func _on_button_pp_pressed() -> void:
	current_p_amount = current_p_amount + p_amount

func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		return
	else:
		selected_powerup = available_powerups[index-1]

func _on_confirmed() -> void:
	# видимо самое простое будет создовать прям сруз всё оверрайды исходя из наминалов базы
	# а потом докидывать powerup #
	var new_enemy_override = EnemyOverrideResource.new()

	#@export var enemy_id: String = "0"
	#@export var enemy_overrided_id: String = "A"
	#@export var health: int = -1
	#@export var points: int = -1
	#@export var self_name: String = ""
	#@export var powerup: PowerupResource

	new_enemy_override.enemy_id = new_symbol
	new_enemy_override.enemy_overrided_id = new_symbol
	new_enemy_override.powerup = selected_powerup
	new_enemy_override.health = current_hp_amount
	new_enemy_override.points = current_p_amount
	
	formation_res.enemy_overrides.append(new_enemy_override)

	UiSignalBus.emit_enemy_editor_refrehs(formation_res)
	if current_hp_amount == 0: 
		print("warning")
	pass # Replace with function body.
